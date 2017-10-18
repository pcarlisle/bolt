require 'spec_helper'
require 'bolt/config'

describe Bolt::Config do
  let(:config) { Bolt::Config.new(a: 1, b: false) }

  describe "when listing keys" do
    it 'returns an empty list of keys for a new config' do
      expect(Bolt::Config.new.keys).to eq([])
    end

    it 'returns a list of keys' do
      expect(config.keys).to match(%i[a b])
    end
  end

  describe "when getting values" do
    it 'returns a truthy value for a key' do
      expect(config.get(:a)).to eq(1)
    end

    it 'returns a false value for a key' do
      expect(config.get(:b)).to eq(false)
    end

    it 'returns a nil value for an absent key' do
      expect(config.get(:z)).to be_nil
    end

    it 'returns a default value for an absent key' do
      expect(config.get(:z, :y)).to eq(:y)
    end
  end

  describe "when setting values" do
    it 'sets a value for a new key' do
      config.set(:n, true)
      expect(config.get(:n)).to eq(true)
    end

    it 'overwrites a value for an existing key' do
      config.set(:a, 42)
      expect(config.get(:a)).to eq(42)
    end
  end
end
