class JobOffer
  include ActiveModel::Validations
  attr_accessor :id, :user, :user_id, :title,
                :location, :description, :is_active,
                :updated_on, :created_on, :validity_date,
                :validity_time, :satisfied

  validates :title, presence: true
  validate :validate_date, :validate_time
  SECONDS_IN_MINUTE = 60
  SECONDS_IN_HOUR = 60 * 60

  def initialize(data = {})
    @id = data[:id]
    @title = data[:title]
    @location = data[:location]
    @description = data[:description]
    @is_active = data[:is_active]
    @user_id = data[:user_id]
    @satisfied = data[:satisfied].nil? ? false : data[:satisfied]
    initialize_dates(data)
  end

  def initialize_dates(data = {})
    @updated_on = data[:updated_on]
    @created_on = data[:created_on]
    @validity_date = data[:validity_date] == '' ? nil : data[:validity_date]
    @validity_time = data[:validity_time] == '' ? nil : data[:validity_time]
  end

  def owner
    user
  end

  def owner=(a_user)
    self.user = a_user
  end

  def activate
    self.is_active = true
  end

  def deactivate
    self.is_active = false
  end

  def satisfied?
    @satisfied
  end

  def satisfy
    raise CantSatisfyOldOffer if old_offer?
    raise AlreadySatisfiedError if @satisfied

    @satisfied = true
  end

  def unsatisfy
    raise CantUnsatisfyExpiredOffer if expired_offer?
    raise CantUnsatisfyOldOffer if old_offer?
    raise NotSatisfiedError unless @satisfied

    @satisfied = false
  end

  def old_offer?
    return (Date.today - updated_on) >= 30 if @validity_date.nil?

    false
  end

  def expired_offer?
    return false if @validity_date.nil?

    expiration_date = Date.strptime(@validity_date, '%Y-%m-%d')

    expire_time = expiration_date.to_time + Time.parse(@validity_time).hour *
                                            SECONDS_IN_HOUR +
                  Time.parse(@validity_time).min * SECONDS_IN_MINUTE

    expire_time < DateTime.now
  end

  def validate_date
    @not_valid = false
    unless @validity_time.nil?
      @not_valid = true if @validity_date.nil?
      errors.add(:validity_date, 'invalid. Must be present if specified a time') if @not_valid
    end
    # return if @validity_date.instance_of? Date # already saved before
    return if @validity_date.nil?

    Date.strptime(@validity_date, '%Y-%m-%d')
  rescue ArgumentError
    @not_valid = true
    errors.add(:validity_date, 'invalid validity date format')
  end

  def validate_time
    @not_valid = false
    unless @validity_date.nil?
      @not_valid = true if @validity_time.nil?
      errors.add(:validity_time, 'invalid. Must be present if specified a date') if @not_valid
    end
    return if @validity_time.nil?

    DateTime.strptime(validity_time, '%H:%M')
  rescue ArgumentError
    @not_valid = true
    errors.add(:validity_time, 'invalid. Must be present if specified a date')
  end
end
