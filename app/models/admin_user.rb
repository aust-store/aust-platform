class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :validatable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :authentication_keys => [:email, :company_id]

  VALID_ROLES = [:founder, :collaborator, :point_of_sale]

  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :company_attributes, :role, :name, :company_id

  validates_presence_of :name, :email
  validates_uniqueness_of :name, scope: :company_id
  validates_uniqueness_of :email, case_sensitive: false
  validates_format_of :email, with: Devise.email_regexp
  validates_presence_of :password, on: :create
  validates_confirmation_of :password, on: :create
  validates_length_of :password, within: Devise.password_length, allow_blank: true

  validates :role,
    inclusion: { in: VALID_ROLES + VALID_ROLES.map(&:to_s) },
    allow_blank: true

  belongs_to :company
  accepts_nested_attributes_for :company

  before_validation :associate_api_token

  def with_company
    self.tap { |t| t.build_company }
  end

  def founder?
    self.role == "founder"
  end

  def point_of_sale?
    self.role == "point_of_sale"
  end

  private

  def associate_api_token
    self.api_token = SecureRandom.hex + Devise.friendly_token if self.api_token.blank?
  end
end
