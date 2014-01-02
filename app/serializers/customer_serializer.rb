class CustomerSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :social_security_number

  def id
    object.uuid
  end
end
