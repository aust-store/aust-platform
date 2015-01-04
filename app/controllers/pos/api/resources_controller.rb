# encoding: utf-8

# This is only accessible in Development and Test environments. It's used by
# external services to test the API contracts.
class Pos::Api::ResourcesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_admin_user!

  def show
    responder = const_get(params[:model])
    render json: {
      params[:model] => {
        attributes:   responder._attributes,
        associations: responder._associations.map { |name, assoc|
          # if a root is not defined, use the association name
          (assoc && assoc[:options] && assoc[:options][:root]) || name
        }
      }
    }
  end

  def const_get(model_name)
    camelized_model = model_name.camelize
    [camelized_model, "#{camelized_model}Serializer"].inject do |memo, model|
      memo = Module.const_get(model) rescue nil
    end
  end
end
