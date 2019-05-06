class JobApplication
  include ActiveModel::Validations

  attr_accessor :applicant_email
  attr_accessor :job_offer

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i


  validates :applicant_email, presence: true, format: { with: VALID_EMAIL_REGEX,
                                              message: ': invalid email' }

  def initialize(data = {})
    @applicant_email = data[:applicant_email]
    @job_offer = data[:job_offer]
  end                                            


  def self.create_for(email, offer)
    app = JobApplication.new
    app.applicant_email = email
    app.job_offer = offer
    app
  end

  def process
    JobVacancy::App.deliver(:notification, :contact_info_email, self)
  end
end
