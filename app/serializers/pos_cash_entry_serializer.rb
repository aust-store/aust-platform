class PosCashEntrySerializer < ActiveModel::Serializer
  attributes :id, :amount, :entry_type, :description, :created_at

  def id
    object.uuid
  end

  def filter(keys)
    if object.admin_user.blank?
      keys.delete(:admin_user)
    end
    keys
  end
end
