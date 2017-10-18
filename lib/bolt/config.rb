module Bolt
  class Config
    def initialize(**kwargs)
      @config = kwargs
    end

    def get(key, default = nil)
      @config.fetch(key)
    rescue KeyError
      default
    end

    def set(key, value)
      @config[key] = value
    end

    def keys
      @config.keys
    end
  end
end
