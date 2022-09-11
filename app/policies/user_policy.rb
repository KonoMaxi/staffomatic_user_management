class UserPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index
    true
  end

  def destroy?
    user !=  record
  end
end