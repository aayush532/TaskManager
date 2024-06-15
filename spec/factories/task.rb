FactoryBot.define do
	factory :task do
		title { "Test Task" }
		deadline { 2.days.from_now }
		status { :backlog }
		association :user
	end
end
  