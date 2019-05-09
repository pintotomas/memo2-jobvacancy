class JobOffer
  include ActiveModel::Validations
  attr_accessor :id, :user, :user_id, :title,
                :location, :description, :is_active,
                :updated_on, :created_on, :validity_date,
                :validity_time

  validates :title, presence: true
  validate :validate_date

  def initialize(data = {})
    @id = data[:id]
    @title = data[:title]
    @location = data[:location]
    @description = data[:description]
    @is_active = data[:is_active]
    @user_id = data[:user_id]
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

  def old_offer?
    return (Date.today - updated_on) >= 30 if @validity_date.nil?

    false
  end

  protected

  def validate_date
    @not_valid = false
    return if @validity_date.nil?

    DateTime.strptime(@validity_date + ' ' + @validity_time, '%Y-%m-%d %H:%M')
  rescue ArgumentError
    @not_valid = true
  end
end
