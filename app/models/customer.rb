class Customer < ActiveRecord::Base
  devise :database_authenticatable,   :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :addresses, as: :addressable
  belongs_to :store, class_name: "Company"

  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :social_security_number,
                  :home_number,      :work_number,      :mobile_number,
                  :home_area_number, :work_area_number, :mobile_area_number,
                  :receive_newsletter,
                  :store, :store_id, :addresses_attributes,
                  :enabled

  usar_como_cpf :social_security_number

  validates :first_name, :last_name, :store, :email, presence: true
  validates :social_security_number, presence: true
  validates :password, :password_confirmation, presence: true, on: :create
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }

  validates :home_number,   presence: { if: :require_home_number? }
  validates :mobile_number, presence: { if: :require_mobile_number? }
  # phone area codes
  validates :home_area_number,   presence: { if: :require_home_area_number? }
  validates :work_area_number,   presence: { if: :require_work_area_number? }
  validates :mobile_area_number, presence: { if: :require_mobile_area_number? }

  accepts_nested_attributes_for :addresses, :store

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

  private

  def require_home_number?
    self.mobile_number.blank?
  end

  def require_mobile_number?
    self.home_number.blank?
  end

  def require_home_area_number?
    self.home_number.present?
  end

  def require_work_area_number?
    self.work_number.present?
  end

  def require_mobile_area_number?
    self.mobile_number.present?
  end

  def self.find_for_authentication(tainted_conditions)
    find_first_by_auth_conditions(tainted_conditions, enabled: true)
  end
end
