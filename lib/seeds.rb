# Dir[File.expand_path('../*', __FILE__)].each { |path| $LOAD_PATH.unshift path }
require_relative './response'
require_relative './crud'

class Seeds
  def initialize(path = Dir.pwd)
    @dir_path = path << '/seeds'
    Dir.mkdir @dir_path unless Dir.exist? @dir_path
    @crud = CRUD.new(@dir_path)
  end

  # Creates a new leaf in the specified seed, seed will be created if it doesn't exist.
  # @param seed [String] name of the seed to create in
  # @param data [Hash] OPTIONAL: Specifies data to be added to the new leaf
  # @return response [Hash] indicates success/failure
  def create(seed, data = {})
    return Response.create_response(false, 'data was not of type Hash') unless data.is_a? Hash
    @crud.create(seed, data)
  end

  # Reads a leaf in the specified seed and returns it.
  # @param seed [String] name of the seed to read from
  # @param rules [Hash] OPTIONAL: Specifies rules for the read
  # @return response [Hash] indicates success/failure, contains results from read if success
  def read(seed, rules = {})
    @crud.read(seed, rules)
  end

  # Updates a leaf in the specified seed.
  # @param seed [String] name of the seed to update in
  # @param data [Hash] updates leaves with data, will overwrite existing data
  # @param rules [Hash] OPTIONAL: Specifies rules for the update
  # @return response [Hash] indicates success/failure
  def update(seed, data, rules = {})
    return Response.create_response(false, 'data was not of type Hash') unless data.is_a? Hash
    @crud.update(seed, data, rules)
  end

  # Deletes a leaf in the specified seed.
  # @param seed [String] name of the seed to read from
  # @param rules [Hash] OPTIONAL: Specifies rules for the update, if no rules specified all leaves will be deleted
  # @return response [Hash] indicates success/failure
  def delete(seed, rules = {})
    @crud.delete(seed, rules)
  end

  # Creates a new seed.
  # @param seed [String] name of the seed to create
  # @return response [Hash] indicates success/failure
  def create_seed(seed)
    @crud.create_seed(seed)
  end

  # Deletes a seed.
  # @param seed [String] name of the seed to delete
  # @return response [Hash] indicates success/failure
  def delete_seed(seed)
    @crud.delete_seed(seed)
  end
end
