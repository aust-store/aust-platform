class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :company_attributes, :role, :name, :company_id

  belongs_to :company
  accepts_nested_attributes_for :company

  def with_company
    self.tap { |t| t.build_company }
  end
end