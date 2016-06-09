class User < ActiveRecord::Base

  mount_uploader :avatar, AvatarUploader

  before_create :generate_authentication_token
  before_save   :downcase_email

  validates :first_name, 	presence: true, length: { maximum: 50 }
  validates :last_name,   	presence: true, length: { maximum: 50 }
  validates :email, 		presence: true, length: { maximum: 255 },
                    uniqueness: { case_sensitive: false }

  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  has_secure_password

  def self.filter(attributes)
    attributes.reduce(all) do |scope, (key, value)|
      if value.present? 
        case key.to_sym
          when :city, :age # direct search
            scope.where(key => value)
          when :keywords # regexp search
             where_args = "%#{value}%".mb_chars.downcase.to_s
             scope.where(["lower(first_name || ' ' || last_name) like :val or lower(last_name || ' ' || first_name) like :val", {val: where_args}])
          else
            scope
        end
      else
        scope
      end
    end  
  end

    # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  private

  # Converts email to all lower-case.
  def downcase_email
    self.email = email.downcase
  end

  def generate_authentication_token
    loop do
      self.authentication_token = SecureRandom.base64(64)
      break unless User.find_by(authentication_token: authentication_token)
    end
  end
end
