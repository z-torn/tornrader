class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable
  
  has_many :prices
  has_many :items, through: :prices
  accepts_nested_attributes_for :prices

  has_many :trades
  has_many :subscriptions
  
  validate :validate_torn_user_id
  validates :torn_user_id, presence: true, uniqueness: { case_sensitive: false }, numericality: { only_integer: true }

  attr_writer :login

  def validate_torn_user_id
    if !ConfirmUser.execute(self.torn_api_key, self.torn_user_id)
      errors.add(:torn_user_id, "Wrong api key or user id, try again")
    end
  end

  def login
    @login || self.torn_user_id
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(torn_user_id) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:torn_user_id) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end
end