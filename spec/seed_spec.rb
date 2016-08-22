require 'spec_helper'
require 'FileUtils'

describe Seeds::Seeds do
  before(:all) do
    @db = Seeds::Seeds.new
  end

  after(:all) do
    # FileUtils.rm(Dir.pwd + '/seeds/test.seed') if File.exist? './seeds/test.seed'
  end

  it('should create a directory at specified location') do
    expect((Dir.exist? './seeds')).to be(true), 'directory was not created'
  end

  it('should be able to create a leaf') do
    @db.create('test', test: 'unit-test-suite')
    response = @db.read('test', test: 'unit-test-suite')
    expect(response[:results][0][:test]).to match('unit-test-suite')
  end

  it('should be able to update an existing leaf') do
    @db.update('test', { test: 'update-test-suite' }, test: 'unit-test-suite')
    response = @db.read('test', test: 'update-test-suite')
    expect(response[:results][0][:test]).to match('update-test-suite')
  end

  it('should be able to delete an existing leaf') do
    @db.create('test', test: 'delete-test')
    response = @db.read('test', test: 'delete-test')
    expect(response[:results][0][:test]).to match('delete-test')

    @db.delete('test', test: 'delete-test')
    response = @db.read('test', test: 'delete-test')
    expect(response[:results].empty?).to be(true)
  end
end
