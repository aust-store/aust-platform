module Models
  module Extensions
    module UUID
      def self.included(base)
        base.extend(ClassMethods)
      end

      def generate_uuid
        if self.public_send(uuid_field).blank?
          self.public_send("#{uuid_field}=", ::SecureRandom.uuid)
        end
      end

      module ClassMethods
        def uuid(options)
          self.before_save :generate_uuid

          define_method :uuid_field do
            return options[:field]
          end
        end
      end
    end
  end
end
