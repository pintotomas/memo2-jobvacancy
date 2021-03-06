JobVacancy::App.controllers :job_offers do
  get :my do
    @offers = JobOfferRepository.new.find_by_owner(current_user)
    @job_applications = JobApplicationRepository.new
    render 'job_offers/my_offers'
  end

  get :index do
    @offers = JobOfferRepository.new.all_active
    render 'job_offers/list'
  end

  get :new do
    @job_offer = JobOffer.new
    render 'job_offers/new'
  end

  get :latest do
    JobOfferRepository.new.deactivate_old_offers
    @offers = JobOfferRepository.new.all_active_and_unsatisfied
    render 'job_offers/list'
  end

  get :edit, with: :offer_id do
    @job_offer = JobOfferRepository.new.find(params[:offer_id])
    # TODO: validate the current user is the owner of the offer
    render 'job_offers/edit'
  end

  get :apply, with: :offer_id do
    @job_offer = JobOfferRepository.new.find(params[:offer_id])
    @job_application = JobApplication.new({})
    # TODO: validate the current user is the owner of the offer
    render 'job_offers/apply'
  end

  post :search do
    @offers = JobOfferRepository.new.search(params[:q])
    render 'job_offers/list'
  end

  post :apply, with: :offer_id do
    @job_offer = JobOfferRepository.new.find(params[:offer_id])
    applicant_email = params[:job_application][:applicant_email]
    bio = params[:job_application][:bio]
    @job_application = JobApplication.new(email: applicant_email, offer: @job_offer,
                                          job_offer_id: @job_offer.id, bio: bio)
    if @job_application.valid?
      JobApplicationRepository.new.save(@job_application)
      @job_application.process(@job_offer)
      flash[:success] = 'Contact information sent.'
      redirect 'job_offers/latest'
    else
      flash[:error] = @job_application.errors.full_messages[0]
      if @job_application.errors.details.key? :offer
        redirect 'job_offers/latest'
      else
        redirect 'job_offers/apply/' + String(@job_offer.id)
      end
    end
  end

  post :create do
    @job_offer = JobOffer.new(job_offer_params)
    @job_offer.owner = current_user
    if JobOfferRepository.new.save(@job_offer)
      TwitterClient.publish(@job_offer) if params['create_and_twit']
      flash[:success] = 'Offer created'
      redirect '/job_offers/my'
    else
      flash.now[:error] = @job_offer.errors.full_messages.join(', ')
      render 'job_offers/new'
    end
  end

  post :update, with: :offer_id do
    @job_offer = JobOffer.new(job_offer_params.merge(id: params[:offer_id]))
    @job_offer.owner = current_user

    if JobOfferRepository.new.save(@job_offer)
      flash[:success] = 'Offer updated'
      redirect '/job_offers/my'
    else
      flash.now[:error] = @job_offer.errors.full_messages.join(', ')
      render 'job_offers/edit'
    end
  end

  put :activate, with: :offer_id do
    @job_offer = JobOfferRepository.new.find(params[:offer_id])
    @job_offer.activate
    if JobOfferRepository.new.save(@job_offer)
      flash[:success] = 'Offer activated'
    else
      flash.now[:error] = 'Operation failed'
    end

    redirect '/job_offers/my'
  end

  put :satisfy, with: :offer_id do
    begin
      @job_offer = JobOfferRepository.new.find(params[:offer_id])
      @job_offer.satisfy
      flash[:success] = 'Offer satisfied!' if JobOfferRepository.new.save(@job_offer)
    rescue AlreadySatisfiedError, CantSatisfyOldOffer, CantSatisfyExpiredOffer
      flash[:error] = 'Operation failed'
      redirect '/'
    end
    redirect '/job_offers/my'
  end

  put :unsatisfy, with: :offer_id do
    begin
      @job_offer = JobOfferRepository.new.find(params[:offer_id])
      @job_offer.unsatisfy
      flash[:success] = 'Offer unsatisfied!' if JobOfferRepository.new.save(@job_offer)
    rescue NotSatisfiedError, CantUnsatisfyExpiredOffer, CantUnsatisfyOldOffer
      flash[:error] = 'Operation failed'
      redirect '/'
    end
    redirect '/job_offers/my'
  end

  delete :destroy do
    @job_offer = JobOfferRepository.new.find(params[:offer_id])
    if JobOfferRepository.new.destroy(@job_offer)
      flash[:success] = 'Offer deleted'
    else
      flash.now[:error] = 'Title is mandatory'
    end
    redirect 'job_offers/my'
  end
end
