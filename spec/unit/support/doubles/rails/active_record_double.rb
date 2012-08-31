module ActiveRecord
  class Base
    class << self
      def belongs_to *args; @@belongs_to_collection = args; end
      def belongs_to_collection; @@belongs_to_collection; end
      def has_one *args; @@has_one = args; end
      def has_one_collection; @@has_one; end
      def has_many *args; @@has_many_collection = args; end
      def has_many_collection; @@has_many_collection; end

      def validates *args; @@validates_collection = args; end
      def validates_collection; @@validates_collection; end

      def before_create *args; @@before_create_colletion = args; end
      def before_create_collection; @@before_create_colletion; end

      def accepts_nested_attributes_for *args
        @@accepts_nested_attributes_for = args
      end

      def accepts_nested_attributes_for_collection
        @@accepts_nested_attributes_for
      end

      def searchable(*args, &block); end

      def scope name, *args
        define_singleton_method name do |a|; end
      end
      def scope_collection; @@scope_collection; end

      def find(id); end
      def new(*args); end
      def create(*args); end
      def save(*args); end
      def destroy(*args); end
    end
  end

  class RecordNotFound < StandardError; end
end
