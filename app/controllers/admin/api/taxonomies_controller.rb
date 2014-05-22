# encoding: utf-8
class Admin::Api::TaxonomiesController < Admin::Api::ApplicationController
  skip_before_filter :authenticate_api_token

  def index
    taxonomies = current_company.taxonomies
    taxonomies = search(taxonomies)
    taxonomies = limit(taxonomies)

    render json: taxonomies
  end
end
