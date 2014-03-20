module Admin
  module Inventory
    class CustomFieldsController < Admin::ApplicationController
      before_action :load_taxonomies, except: [:index, :destroy]

      def index
        # only inventory items
        @resources = current_company.custom_fields.to_a
      end

      def new
        @resource = CustomField.new
        @resource.options = { "values" => "[\"\", \"\"]" }
        @taxonomies = current_company.taxonomies.roots
      end

      def edit
        @resource = current_company.custom_fields.find(params[:id])
      end

      def create
        @resource = current_company.custom_fields.new(resource_params)
        @resource.related_type = "InventoryItem"
        if @resource.save
          redirect_to admin_inventory_custom_fields_url,
            notice: "Campo criado com sucesso."
        else
          render :new
        end
      end

      def update
        @resource = current_company.custom_fields.find(params[:id])
        if @resource.update_attributes(resource_params)
          redirect_to admin_inventory_custom_fields_url,
            notice: "Campo salvo com sucesso."
        else
          render :edit
        end
      end

      private

      def resource_params
        params.require(:custom_field)
              .permit(:name, :field_type,
                      :taxonomy_ids => [],
                      :options => { :values => [] })
      end

      def load_taxonomies
        @taxonomies = current_company.taxonomies.roots
      end
    end
  end
end
