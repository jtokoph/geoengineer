require_relative '../spec_helper'
require_relative './test_nodes'

describe GeoEngineer::GPS::Constants do
  it 'sets the name' do
    c = GeoEngineer::GPS::Constants.new({ "e": {} })
    expect(c.dereference("e", "name")).to eq "e"
  end

  context 'dereference' do
    it 'looks in _global env' do
      c = GeoEngineer::GPS::Constants.new({ "e": {}, "_global": { "test": "hello" } })
      expect(c.dereference("e", "test")).to eq "hello"
    end

    it 'is overriden by env' do
      c = GeoEngineer::GPS::Constants.new({ "e": { "test": "no" }, "_global": { "test": "hello" } })
      expect(c.dereference("e", "test")).to eq "no"
    end
  end

  context 'yamltags' do
    it 'properly dereferences tags' do
      yaml = YAML.load("
_global:
  test: 'hello'
  test2: !ref constant::test
e1: {}
e2:
  test: 'no'
  test3: !ref constant::test
      ")
      c = GeoEngineer::GPS::Constants.new(yaml)
      expect(c.dereference("e1", "test")).to eq "hello"
      expect(c.dereference("e1", "test2")).to eq "hello"

      expect(c.dereference("e2", "test")).to eq "no"
      expect(c.dereference("e2", "test2")).to eq "hello"
      expect(c.dereference("e2", "test3")).to eq "no"
    end
  end
end