class JobApplicationRepository < BaseRepository
  self.table_name = :job_applications
  self.model_class = 'JobApplication'
  def find_by_offer(offer)
    load_collection dataset.where(job_offer_id: offer.id)
  end

  protected

  def changeset(application)
    {
      email: application.applicant_email,
      job_offer_id: application.job_offer_id,
      bio: application.bio
    }
  end
end
