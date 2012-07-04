module Store
  module ModelsExtensions
    module Good
      def self.included(model)
        model.extend(ClassMethods)
      end

      module ClassMethods
        def find_and_build_image(good_id)
          good = find(good_id)
          good.tap { |s| s.images.build }
        end
      end
    end
  end
end
