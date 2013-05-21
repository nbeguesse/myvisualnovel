class User < ActiveRecord::Base

  # PATH = '/logos/:id/:style.:extension'
  # opts =
  #         case Settings.storage.storage.to_sym
  #           when :filesystem
  #             {
  #                     :path => ':rails_root/public' + PATH,
  #                     :url => PATH,
  #                     :default_url => '/images/missing-car/:style.jpg'
  #             }
  #           when :s3
  #             {
  #                     :path => PATH,
  #                     :storage => :s3,
  #                     :url => PATH,
  #                     :bucket => Settings.storage.bucket,
  #                     :s3_options => { :port => 80 },
  #                     :s3_credentials => {
  #                       :access_key_id => Settings.storage.s3_credentials.access_key_id,
  #                       :secret_access_key => Settings.storage.s3_credentials.secret_access_key
  #                     },
  #                     :s3_protocol => 'http',
  #                     :s3_permissions => :public_read
  #             }
  #         end.update({
  #                 :styles => { :small => "x50", :medium => "x150" }
  #         })
  # has_attached_file :logo, opts
  # attr_accessor :skip_state_validation

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



end


