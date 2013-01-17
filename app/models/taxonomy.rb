class Taxonomy < ActiveRecord::Base
  acts_as_tree order: 'id'

  belongs_to :store, foreign_key: 'store_id', class_name: "Company"
  attr_accessible :name, :parent_id, :store_id

  def self.hash_tree_for_homepage(depth = 2)
    self.hash_tree(limit_depth: depth)
  end

  # .flat_hash_tree
  #
  # converts this:
  #
  #   anakin: { vader: {},
  #             luke:  {} },
  #   ben:    {}
  #
  # in:
  #
  #   [ anakin, vader, luke, ben ]
  #
  # returns all nodes in a flat array
  def self.flat_hash_tree(tree = self.hash_tree, result = [])
    tree.each do |node, children|
      result << node
      if children.present?
        self.flat_hash_tree(children, result)
      end
    end
    result
  end
end
