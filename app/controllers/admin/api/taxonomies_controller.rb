# encoding: utf-8
class Admin::Api::TaxonomiesController < Admin::Api::ApplicationController
  def index
    taxonomies = current_company.taxonomies
    taxonomies = search(taxonomies)
    taxonomies = limit(taxonomies)

    render json: taxonomies
  end

  private

  def search(taxonomies)
    taxonomies = taxonomies.search_for(params[:search]) if params[:search].present?
    taxonomies
  end

  def limit(taxonomies)
    taxonomies = taxonomies.limit(3)
    Rails.logger.info params.inspect
    if params[:limit].to_i.present? && params[:limit].to_i > 0
      taxonomies = taxonomies.limit(params[:limit].to_i)
    end
    taxonomies
  end
end
