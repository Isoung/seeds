require 'lru_redux'
require_relative 'response'
require_relative 'leaf'

module Seeds
  class CRUD
    def initialize(path)
      @dir = path
      @cache = LruRedux::Cache.new(10)
    end

    def create(seed_name, data)
      seed = get_seed(seed_name)
      seed = create_seed(seed_name) if seed.nil?
      success = Leaf.create_leaf(seed, data)

      @cache[seed_name.to_sym] = seed
      update_file(seed, seed_name)

      return Response.create_response(false, 'Unable to create leaf') unless success
      Response.create_response(true, "Success leaf was created and added to #{seed_name}")
    end

    def read(seed_name, rules)
      seed = get_seed(seed_name)
      return Response.create_response(false, "#{seed_name} seed was not found!") if seed.nil?
      response = Leaf.read_leaf(seed[:leaves], rules)

      return Response.create_response(false, 'No leaves contained specified rules') if response.nil?
      Response.create_response(true, 'Success', results: response)
    end

    def update(seed_name, data, rules)
      seed = get_seed(seed_name)
      return Response.create_response(false, "#{seed_name} seed was not found!") if seed.nil?
      success = Leaf.update_leaf(seed[:leaves], data, rules)

      @cache[seed_name.to_sym] = seed
      update_file(seed, seed_name)

      return Response.create_response(false, 'No leaves contained specified rules') unless success
      Response.create_response(true, "Success leaves were updated in #{seed_name}")
    end

    def delete(seed_name, rules)
      seed = get_seed(seed_name)
      return Response.create_response(false, "#{seed_name} seed was not found!") if seed.nil?
      success = Leaf.delete_leaf(seed[:leaves], rules)

      @cache[seed_name.to_sym] = seed
      update_file(seed, seed_name)

      return Response.create_response(false, 'No leaves contained specified rules') unless success
      Response.create_response(true, "Success leaves were deleted in #{seed_name}")
    end

    private

    def get_seed_path(seed)
      @dir + "/#{seed}.seed"
    end

    def get_seed(seed)
      seed_path = get_seed_path(seed)
      return @cache[seed.to_sym] unless @cache[seed.to_sym].nil?
      loaded_seed = Marshal.load(File.open(seed_path)) if File.exist? seed_path
      @cache[seed.to_sym] = loaded_seed
      loaded_seed
    end

    def create_seed(seed)
      seed_path = get_seed_path(seed)
      seed_template = {
        name: seed,
        creation_date: Time.now.strftime('%d/%m/%Y %H:%M'),
        leaves: []
      }

      File.open(seed_path, 'w') { |file| file.write(Marshal.dump(seed_template)) }
      seed_template
    end

    def update_file(seed, seed_name)
      File.open(get_seed_path(seed_name), 'w') { |file| file.write(Marshal.dump(seed)) }
    end
  end
end
