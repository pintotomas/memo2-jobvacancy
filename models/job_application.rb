class JobApplication
  include ActiveModel::Validations
  attr_accessor :applicant_email, :id, :job_offer_id,
                :updated_on, :created_on, :job_offer, :bio

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  validates :applicant_email, presence: true, format: { with: VALID_EMAIL_REGEX,
                                                        message: ': invalid format' }

  validates :bio, presence: true, length: { minimum: 1, maximum: 500 }, allow_blank: false
  validate :validate_offer_satisfaction
  validate :validate_offer_is_old
  def initialize(data)
    @job_offer = data[:offer]
    @id = data[:id]
    @job_offer_id = data[:job_offer_id]
    @applicant_email = data[:email]
    @updated_on = data[:updated_on]
    @created_on = data[:created_on]
    @bio = data[:bio]
  end

  def process(offer)
    @job_offer = offer
    JobVacancy::App.deliver(:notification, :contact_info_email, self)
  end

  protected

  def validate_offer_is_old
    return if @job_offer.nil?
    return unless @job_offer.expired_offer? || @job_offer.old_offer?

    @not_valid = true
    errors.add(:offer, 'expired before you completed your application')
  end

  def validate_offer_satisfaction
    return if @job_offer.nil?
    return unless @job_offer.satisfied?

    @not_valid = true
    errors.add(:offer, 'was satisfied before you completed your application')
  end
end
