class Customer < ActiveRecord::Base
  devise :database_authenticatable,   :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :social_security_number,
                  :home_number,      :work_number,      :mobile_number,
                  :home_area_number, :work_area_number, :mobile_area_number,
                  :receive_newsletter,
                  :store, :store_id, :addresses_attributes

  usar_como_cpf :social_security_number

  validates :first_name, :last_name, presence: true
  validates :store, presence: true
  validates :social_security_number, presence: true
  validates :email, :password, :password_confirmation, presence: true
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }

  validates :home_number,   presence: { unless: Proc.new { |a| a.mobile_number.present? } }
  validates :mobile_number, presence: { unless: Proc.new { |a| a.home_number.present? } }

  # phone area codes
  validates :home_area_number,   presence: { if: Proc.new { |a| a.home_number.present? } }
  validates :work_area_number,   presence: { if: Proc.new { |a| a.work_number.present? } }
  validates :mobile_area_number, presence: { if: Proc.new { |a| a.mobile_number.present? } }

  has_many :addresses, as: :addressable
  belongs_to :store, class_name: "Company"

  accepts_nested_attributes_for :addresses, :store

  def default_address
    if addresses.present?
      addresses.where(default: true).first
    else
      raise "User has no address"
    end
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
end
