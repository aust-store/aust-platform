class Admin::TaxonomiesController < Admin::ApplicationController
  def index
    @taxonomies = current_company.taxonomies.hash_tree
  end

  def create
    @taxonomy = current_company.taxonomies.build(parent_id: params[:parent_id],
                                                 name:      params[:name])
    if @taxonomy.save
      render json: @taxonomy, status: 200
    else
      render nothing: true, status: 406
    end
  end

  def update
    @taxonomy = current_company.taxonomies.find(params[:id])
    if @taxonomy.update_attributes(name: params[:name])
      render nothing: true, status: 204
    else
      render nothing: true, status: 406
    end
  end

  def delete
    @taxonomy = current_company.taxonomies.find(params[:id])
    if @taxonomy.destroy
      render nothing: true, status: 204
    else
      render nothing: true, status: 406
    end
  end
end
