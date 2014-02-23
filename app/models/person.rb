class Person < ActiveRecord::Base
  extend Models::Extensions::FullTextSearch
  include Models::Extensions::UUID

  uuid field: "uuid"

  VALID_ENVIRONMENTS = ["admin", "website", "point_of_sale"]
  # Used for creating users at the Point of Sale, customers which won't have
  # any sign in access. Devise requires a password and we couldn't allow
  # anyone to use a blank password to sign anyway.
  DUMMY_PASSWORD_FOR_POINT_OF_SALE = "dummy_password_for_point_of_sale_customers"

  devise :database_authenticatable,   :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :addresses, as: :addressable
  has_many :person_roles
  has_many :roles, through: :person_roles
  belongs_to :store, class_name: "Company"


  # FIXME - remove this
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name,
                  :social_security_number,
                  :company_id_number,
                  :home_number,      :work_number,      :mobile_number,
                  :home_area_number, :work_area_number, :mobile_area_number,
                  :receive_newsletter,
                  :store, :store_id, :addresses_attributes,
                  :environment, :uuid,
                  :enabled,
                  :role_ids, :role,
                  :addresses

  # validations: always (both website and point of sale)
  validates :store, presence: true
  validates :environment, inclusion: {in: VALID_ENVIRONMENTS}
  validates :first_name, presence: true

  # validations: website
  validate :validate_customer_from_website

  # validations details
  validate :valid_social_security_number?
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
    allow_blank: true

  before_validation :avoid_address_validation
  before_validation :fulfill_dummy_password_for_customer
  before_save :sanitize_social_security_number

  accepts_nested_attributes_for :addresses, :store, :roles

  def self.search_for(query)
    search do
      fields :first_name, :last_name, :social_security_number, :email
      keywords query
    end
  end

  def social_security_number
    super.to_s
  end

  def default_address
    if addresses.present?
      addresses.where(default: true).first
    else
      raise "User has no address"
    end
  end

  def enable
    self.update_attributes(enabled: true)
  end

  def disable
    self.update_attributes(enabled: false)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def first_phone_number
    if home_number
      { area:  home_area_number,
        phone: home_number }
    elsif mobile_number
      { area:  mobile_area_number,
        phone: mobile_number }
    elsif work_number
      { area:  work_area_number,
        phone: work_number }
    end
  end

  def customer?
    self.roles.any? { |role| role.name == "customer" }
  end

  def supplier?
    self.roles.any? { |role| role.name == "supplier" }
  end

  def update_attributes_with_minimal_validation(params = {})
    @minimal_validation_mode = true
    update_attributes(params)
  end

  def save_with_minimal_validation
    @minimal_validation_mode = true
    save
  end

  def minimal_validation?
    @minimal_validation_mode.nil? ? false : @minimal_validation_mode
  end

  def company?
    self.company_id_number.present?
  end

  private

  def avoid_address_validation
    if minimal_validation?
      self.addresses.each { |a| a.do_not_validate }
    end
  end

  def self.find_for_authentication(tainted_conditions)
    find_first_by_auth_conditions(tainted_conditions, enabled: true)
  end

  # Used by Devise
  #
  # Only users that have a password are allowed to sign in
  def self.find_for_database_authentication(conditions={})
    self
      .where("email = ?", conditions[:email])
      .where("has_password = ?", true)
      .limit(1)
      .first
  end

  def email_required?
    false
  end

  def sanitize_social_security_number
    self.social_security_number = social_security_number.to_s.gsub(/[\.|\-|\s]/, '')
  end

  def valid_social_security_number?
    if Rails.env.development?
      return true if self.social_security_number.to_s.size > 0
    end

    if self.social_security_number.present? && self.company_id_number.present?
      # CPF is the brazilian social number
      errors.add(:social_security_number, :is_company)
    end

    if self.social_security_number.present?
      # CPF is the brazilian social number
      errors.add(:social_security_number, :invalid) unless ::Cpf.new(self.social_security_number).valido?
    end
  end

  def validate_customer_from_website
    if website? && !minimal_validation?
      Models::Validation::CustomerFromWebsite.new(self).validate
    end
  end

  def website?
    self.environment == "website"
  end

  def created_on_admin?
    self.environment == "admin"
  end

  def point_of_sale?
    self.environment == "point_of_sale"
  end

  def fulfill_dummy_password_for_customer
    if (point_of_sale? || created_on_admin?) && self.password.blank?
      self.has_password = false
      self.password = DUMMY_PASSWORD_FOR_POINT_OF_SALE
      self.password_confirmation = DUMMY_PASSWORD_FOR_POINT_OF_SALE
    end
  end
end
