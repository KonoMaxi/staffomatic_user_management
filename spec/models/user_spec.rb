require 'rails_helper'

RSpec.describe User, type: :model do
  fixtures :users

  subject do
    described_class.new(
      email: 'daniel@example.com',
      password: 'someweiredpassword',
      password_confirmation: 'someweiredpassword',
    )
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without email' do
    subject.email = nil
    expect(subject).to_not be_valid
  end

  it 'has valid email' do
    subject.email = "invalid_email_address"
    expect(subject).to_not be_valid
  end

  it 'generates an audit entry on archive' do
    user = users(:one)
    expect(user.audits.count).to equal(0)
    user.update(archive: true)
    expect(user.audits.count).to equal(1)
  end

  it 'generates an audit entry on delete' do
    user = users(:one)
    expect(user.audits.count).to equal(0)
    user.destroy
    expect(user.audits.count).to equal(1)
  end

  it 'is not be valid without matching password' do
    subject.password = 'someweiredpassword!!'
    subject.password_confirmation = 'someweiredpassword'
    expect(subject).to_not be_valid
  end
end
