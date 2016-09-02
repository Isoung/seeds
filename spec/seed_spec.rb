require 'spec_helper'
require 'FileUtils'

describe Seeds do
  before(:all) do
    @db = Seeds.new
  end

  after(:all) do
    FileUtils.rm(Dir.pwd + '/seeds/test.seed') if File.exist? './seeds/test.seed'
    FileUtils.rm(Dir.pwd + '/seeds/testdb.seed') if File.exist? './seeds/testdb.seed'
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
    expect(response[:results].nil?).to be(true)
  end

  it('should return false when trying to read a nonexistent seed') do
    response = @db.read('does_not_exist')
    expect(response[:success]).to be(false)
    expect(response[:error]).to match('does_not_exist seed was not found')
  end

  it('should return false when no leaves found') do
    response = @db.read('test', non_existent: true)
    expect(response[:success]).to be(false)
    expect(response[:error]).to match('No leaves found containing specified rules')
  end

  it('should be able to create a seed') do
    response = @db.create_seed('testdb')
    expect(response[:success]).to be(true)
    expect((File.exist? './seeds/testdb.seed')).to be(true)
  end

  it('should be able to delete a seed') do
    response = @db.create_seed('seed2delete')
    expect(response[:success]).to be(true)
    expect((File.exist? './seeds/seed2delete.seed')).to be(true)

    response = @db.delete_seed('seed2delete')
    expect(response[:success]).to be(true)
    expect((File.exist? './seeds/seed2delete.seed')).to be(false)
  end
end
