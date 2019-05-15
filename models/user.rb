class User
  include ActiveModel::Validations

  attr_accessor :id, :name, :email, :crypted_password, :job_offers,
                :updated_on, :created_on, :password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  PASSWORD_VALIDATOR = /(      # Start of group
  (?:                        # Start of nonmatching group, 4 possible solutions
    (?=.*[a-z])              # Must contain one lowercase character
    (?=.*[A-Z])              # Must contain one upercase character
    ((?=.*\d)|(?=.*\W+))     # Must contain one number or not word
  )                          # End of nonmatching group with possible solutions
  .*                         # Match anything with previous condition checking
)/x # End of group

  validates :name, :crypted_password, :password, presence: true
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX,
                                              message: 'invalid email' }
  validate :validate_password

  def initialize(data = {})
    @id = data[:id]
    @name = data[:name]
    @email = data[:email]
    @password = data[:password]
    @crypted_password = if @password.nil?
                          data[:crypted_password]
                        else
                          Crypto.encrypt(@password)
                        end
    @job_offers = data[:job_offers]
    @updated_on = data[:updated_on]
    @created_on = data[:created_on]
  end

  def has_password?(password)
    Crypto.decrypt(crypted_password) == password
  end

  private

  def validate_password
    aplicate_regex = @created_on.nil? && !PASSWORD_VALIDATOR.match?(@password)
    errors.add(:password, 'invalid format') if aplicate_regex
    has_eight_characters = @created_on.nil? && !@password.nil? && @password.length == 8
    errors.add(:password, 'Must have 8 characters') unless has_eight_characters
  end
end
