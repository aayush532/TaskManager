require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'requires email to be present' do
      user = User.new(password: 'password')
      user.valid?
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'requires password to be present on create' do
      user = User.new(email: 'test@example.com')
      user.valid?
      expect(user.errors[:password]).to include("can't be blank")
    end

    it 'validates email format' do
      user = User.new(email: 'invalid_email', password: 'password')
      user.valid?
      expect(user.errors[:email]).to include('is invalid')
    end

    it 'validates password length' do
      user = User.new(email: 'test@example.com', password: 'pass')
      user.valid?
      expect(user.errors[:password]).to include('is too short (minimum is 6 characters)')
    end
  end

  describe 'associations' do
    it 'has many tasks that are dependent on destroy' do
      user = User.reflect_on_association(:tasks)
      expect(user.macro).to eq(:has_many)
    end
  end
end
