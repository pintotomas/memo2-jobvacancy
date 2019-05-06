class JobApplication
  attr_accessor :applicant_email, :id, :job_offer_id
  include ActiveModel::Validations

  def initialize(data)
    @id = data[:id]
    @job_offer_id = data[:job_offer_id]
    @applicant_email = data[:email]
  end

  def process
    JobVacancy::App.deliver(:notification, :contact_info_email, self)
  end
end
