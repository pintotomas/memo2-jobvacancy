class JobApplication
  include ActiveModel::Validations
  attr_accessor :applicant_email, :id, :job_offer_id,
                :updated_on, :created_on, :job_offer

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  validates :applicant_email, presence: true, format: { with: VALID_EMAIL_REGEX,
                                                        message: ': invalid format' }

  def initialize(data)
    @id = data[:id]
    @job_offer_id = data[:job_offer_id]
    @applicant_email = data[:email]
    @updated_on = data[:updated_on]
    @created_on = data[:created_on]
  end

  def process(offer)
    @job_offer = offer
    JobVacancy::App.deliver(:notification, :contact_info_email, self)
  end
end
