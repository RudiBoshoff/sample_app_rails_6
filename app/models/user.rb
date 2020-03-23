class User < ApplicationRecord
    attr_accessor :remember_token, :activation_token
    before_save :downcase_email
    before_create :create_activation_digesxt
    
    validates :name,
    presence: true,
    length: { maximum: 50 }

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email,
              presence: true,
              length: { maximum: 255 },
              format: { with: VALID_EMAIL_REGEX },
              uniqueness: true

    has_secure_password

    validates :password, length: { minimum: 6 }, presence: true, allow_nil: true
     
    class << self
        
        # returns the hash digest (or "encrypted" form) of the given string
        def digest(string)
            cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
            BCrypt::Engine.cost
            BCrypt::Password.create(string, cost: cost) 
        end
        
        # Returns a random token
        def new_token
            SecureRandom.urlsafe_base64
        end
    end

    # Remembers a user in the database for use in persistent sessions
    def remember

        # get random new token
        self.remember_token = User.new_token

        # update the database using the "encrypted" form of the new token
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    # returns true if the digest of the given token matches the given digest
    # loosly: returns true if the encryption of the given token matches the encryption of the already encrypted password
    def authenticated?(attribute, token)
        digest = send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
    end
    
    # Forgets a user
    def forget
        update_attribute(:remember_digest, nil)
    end

    # Activates an account
    def activate
        update_columns(activated: true, activated_at: Time.zone.now)
    end

    # Sends activation email
    def send_activation_email
        UserMailer.account_activation(self).deliver_now
    end

    private

        # Converts email to lower case
        def downcase_email
            email.downcase!
        end

        # creates and assigns the activation token and activation digest
        def create_activation_digesxt
            self.activation_token = User.new_token
            self.activation_digest = User.digest(activation_token)
        end
end
