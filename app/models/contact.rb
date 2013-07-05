class Contact < ActiveRecord::Base
  belongs_to :contactable, polymorphic: true

  validates :email, :phone_1, presence: true
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
end
