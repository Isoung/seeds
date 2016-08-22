require 'securerandom'

module Seeds
  module Leaf
    def self.create_leaf(seed, data)
      leaf_template = {
        uid: SecureRandom.hex,
        creation_date: Time.now.strftime('%d/%m/%Y %H:%M')
      }

      seed[:leaves] << if data.length >= 1
                         add_data(leaf_template, data)
                       else
                         leaf_template
                       end

      return true unless find_leaf(seed[:leaves], leaf_template[:uid]).nil?
      false
    end

    def self.read_leaf(leaves, rules)
      return leaves unless rules.length >= 1
      return find_leaf(leaves, rules[:uid]) unless rules[:uid].nil?
      search_for_leaves(leaves, rules.to_a)
    end

    def self.update_leaf(leaves, data, rules)
      results = rules.length >= 1 ? search_for_leaves(leaves, rules.to_a) : leaves
      results.length.times do |i|
        add_data(leaves[i], data, true)
      end

      false unless results.length >= 1
      true
    end

    def self.delete_leaf(leaves, rules)
      results = rules.length >= 1 ? search_for_leaves(leaves, rules.to_a) : leaves
      results.each do |leaf|
        leaves.delete(leaf)
      end

      false unless results.length >= 1
      true
    end

    # Private methods

    def self.search_for_leaves(leaves, rules)
      result = leaves
      rules.each do |rule|
        result = result.select { |leaf| leaf[rule[0].to_sym] == rule[1] }
      end
      result
    end

    def self.find_leaf(leaves, uid)
      leaves.find { |leaf| leaf[:uid] == uid }
    end

    def self.add_data(template, data, overwrite = false)
      data.each do |key, value|
        template[key] = value unless (template.key? key) && !overwrite
      end
      template
    end

    private_class_method :search_for_leaves
    private_class_method :find_leaf
    private_class_method :add_data
  end
end
