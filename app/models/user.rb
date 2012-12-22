class User < ActiveRecord::Base
  devise :database_authenticatable,   :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  usar_como_cpf :social_security_number

  validates :first_name, :last_name, presence: true
  validates :social_security_number, presence: true
  validates :email, :password, :password_confirmation, presence: true
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :home_number, presence: { unless: Proc.new { |a| a.mobile_number.present? } }
  validates :mobile_number, presence: { unless: Proc.new { |a| a.home_number.present? } }

  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :social_security_number,
                  :home_number, :work_number, :mobile_number,
                  :receive_newsletter,
                  :addresses_attributes

  has_many :addresses, as: :addressable

  accepts_nested_attributes_for :addresses
end
