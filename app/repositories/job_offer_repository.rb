class JobOfferRepository < BaseRepository
  self.table_name = :job_offers
  self.model_class = 'JobOffer'

  def all_active
    load_collection dataset.where(is_active: true)
  end

  def all_unsatisfied
    load_collection dataset.where(satisfied: false)
  end

  def all_active_and_unsatisfied
    load_collection dataset.where(satisfied: false, is_active: true)
  end

  def find_by_owner(user)
    load_collection dataset.where(user_id: user.id)
  end

  def find_by_id(id)
    load_collection dataset.where(id: id)
  end

  def find_by_title(title)
    load_collection dataset.where(title: title)
  end

  def deactivate_old_offers
    all_active.each do |offer|
      if offer.old_offer? || offer.expired_offer?
        offer.deactivate
        update(offer)
      end
    end
  end

  def search(term)
    load_collection dataset.where(Sequel.like(:title, "%#{term}%", case_insensitive: true))
      .or(Sequel.like(:description, "%#{term}%", case_insensitive: true))
                           .or(Sequel.like(:location, "%#{term}%", case_insensitive: true))
  end

  protected

  def load_object(a_record)
    job_offer = super
    # TODO: Eager load user to avoid N+1 queries
    user = UserRepository.new.find(job_offer.user_id)
    job_offer.owner = user
    job_offer
  end

  def changeset(offer)
    {
      title: offer.title,
      location: offer.location,
      validity_date: offer.validity_date,
      validity_time:  offer.validity_time,
      description: offer.description,
      is_active: offer.is_active,
      user_id: offer.owner&.id || offer.user_id,
      satisfied: offer.satisfied,
      experience: offer.experience
    }
  end
end
