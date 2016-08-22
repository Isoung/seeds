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

      true
    end

    def self.read_leaf(leaves, rules)
      return leaves unless rules.length >= 1
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
      return leaves unless rules.length >= 1

      rule = rules.pop
      results = leaves.select { |leaf| leaf[rule[0]] == rule[1] }

      return search_for_leaves(results, rules) unless rules.empty? || results.empty?
      results
    end

    def self.add_data(template, data, overwrite = false)
      data.each do |key, value|
        template[key] = value unless (template.key? key) && !overwrite
      end
      template
    end

    private_class_method :search_for_leaves
    private_class_method :add_data
  end
end
