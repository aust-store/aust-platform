class CompanySerializer < ActiveModel::Serializer
  attributes :id, :name, :handle, :created_at

  def attributes
    hash = super
    if object.include_statistics?
      hash['total_items'] = object.statistics[:total_items]
    end
    hash
  end
end
