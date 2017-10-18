require 'spec_helper'
require 'bolt/config'

describe Bolt::Config do
  let(:config) { Bolt::Config.new }

  describe "when initializing" do
    it "accepts keyword values" do
      config = Bolt::Config.new(concurrency: 200)
      expect(config.concurrency).to eq(200)
    end

    it "uses a default value when none is given" do
      config = Bolt::Config.new
      expect(config.concurrency).to eq(100)
    end

    it "rejects unknown keys" do
      expect {
        Bolt::Config.new(what: 'why')
      }.to raise_error(NameError)
    end
  end
end
