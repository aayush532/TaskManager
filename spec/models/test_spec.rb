require 'spec_helper'
require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    it 'requires deadline to be present' do
			task = Task.new(title: 'Example Task', description: 'Example description', status: :backlog)
			task.valid?
			expect(task.errors[:deadline]).to include("can't be blank")
		end

		it 'requires status to be present' do
			task = Task.new(title: 'Example Task', description: 'Example description', deadline: 1.day.from_now)
			task.valid?
			expect(task.errors[:status]).to include("can't be blank")
		end

    it 'validates deadline cannot be in the past' do
      task = Task.new(deadline: 1.day.ago, status: :backlog)
      task.valid?
      expect(task.errors[:deadline]).to include("can't be in the past")
    end

    it 'validates deadline must be at least 12 hours from now' do
      task = Task.new(deadline: 10.hours.from_now, status: :backlog)
      task.valid?
      expect(task.errors[:deadline]).to include("must be at least 12 hours from now")
    end
  end
end
