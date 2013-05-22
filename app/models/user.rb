class User < ActiveRecord::Base
  attr_accessor :agree_to_terms
  before_create :require_agree_terms
  attr_accessible :email, :password, :password_confirmation, :agree_to_terms

  def require_agree_terms
    unless self.agree_to_terms
      self.errors.add :base, "You must agree to the Terms and Conditions to continue."
      return false
    end
  end

  acts_as_authentic do |config|
    config.login_field :email
    config.validate_login_field false
    config.validates_length_of_password_confirmation_field_options :minimum => 0, :if => :require_password?
    config.crypto_provider = Authlogic::CryptoProviders::BCrypt
    config.transition_from_crypto_providers = Authlogic::CryptoProviders::Sha512
  end

  has_many :projects, :as=>:owner, :dependent => :destroy

  def projects
    Project.where(:owner_id=>self.id.to_s)
  end

  def type
    "User"
  end

  def may_login?
    true
  end



end


