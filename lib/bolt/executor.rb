require 'concurrent'
require 'bolt/result'

module Bolt
  class Executor
    def initialize(config)
      @config = config
    end

    def from_uris(nodes)
      nodes.map do |node|
        Bolt::Node.from_uri(node, config: @config)
      end
    end

    def on(nodes)
      results = Concurrent::Map.new

      poolsize = [nodes.length, @config.get(:concurrency, 100)].min
      pool = Concurrent::FixedThreadPool.new(poolsize)
      nodes.each { |node|
        pool.post do
          results[node] =
            begin
              node.connect
              yield node
            rescue Bolt::Node::BaseError => ex
              Bolt::ErrorResult.new(ex.message, ex.issue_code, ex.kind)
            rescue StandardError => ex
              node.logger.error(ex)
              Bolt::ExceptionResult.new(ex)
            ensure
              node.disconnect
            end
        end
      }
      pool.shutdown
      pool.wait_for_termination

      results_to_hash(results)
    end

    def run_command(nodes, command)
      on(nodes) do |node|
        node.run_command(command)
      end
    end

    def run_script(nodes, script)
      on(nodes) do |node|
        node.run_script(script)
      end
    end

    def run_task(nodes, task, input_method, arguments)
      on(nodes) do |node|
        node.run_task(task, input_method, arguments)
      end
    end

    def file_upload(nodes, source, destination)
      on(nodes) do |node|
        node.upload(source, destination)
      end
    end

    private

    def results_to_hash(results)
      result_hash = {}
      results.each_pair { |k, v| result_hash[k] = v }
      result_hash
    end
  end
end
