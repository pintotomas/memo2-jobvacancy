class JobApplication
  include ActiveModel::Validations
  attr_accessor :applicant_email
  attr_accessor :job_offer

  validates :applicant_email, presence: true

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
