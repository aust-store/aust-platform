class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :validatable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :authentication_keys => [:company_id]

  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :company_attributes, :role, :name, :company_id

  validates_presence_of :name, :email
  validates_uniqueness_of :name, :scope => :company_id
  validates_uniqueness_of :email, case_sensitive: false
  validates_format_of :email, with: Devise.email_regexp
  validates_presence_of :password, on: :create
  validates_confirmation_of :password, on: :create
  validates_length_of :password, within: Devise.password_length, allow_blank: true

  belongs_to :company
  accepts_nested_attributes_for :company

  def with_company
    self.tap { |t| t.build_company }
  end
end
