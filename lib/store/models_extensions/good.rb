module Store
  module ModelsExtensions
    module Good
      def self.included(model)
        model.extend(ClassMethods)
      end

      module ClassMethods
      end
    end
  end
end
