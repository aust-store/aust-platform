module Models
  module Validation
    class CustomerFromWebsite
      def initialize(record)
        @record = record
        @valid = true
      end

      def validate
        invalidate_blank(:email)
        invalidate_blank(:last_name)
        invalidate_blank(:password, on: :create)
        invalidate_blank(:password_confirmation, on: :create)
        invalidate_blank(:social_security_number) if record.company_id_number.blank?

        invalidate_blank(:home_number) if require_home_number?
        invalidate_blank(:mobile_number) if require_mobile_number?

        # # phone area codes
        invalidate_blank(:home_area_number) if require_home_area_number?
        invalidate_blank(:work_area_number) if require_work_area_number?
        invalidate_blank(:mobile_area_number) if require_mobile_area_number?
        @valid
      end

      private

      attr_reader :record

      def add_error(field, error)
        @valid = false
        record.errors.add(field, error)
      end

      def invalidate_blank(field, options = {})
        on = options[:on]
        return if !record.new_record? && on == :create
        return if  record.new_record? && on == :update
        add_error(field, :blank) if record.public_send(field).blank?
      end

      def require_home_number?
        record.mobile_number.blank?
      end

      def require_mobile_number?
        record.home_number.blank?
      end

      def require_home_area_number?
        record.home_number.present?
      end

      def require_work_area_number?
        record.work_number.present?
      end

      def require_mobile_area_number?
        record.mobile_number.present?
      end
    end
  end
end
