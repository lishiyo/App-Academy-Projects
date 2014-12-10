FactoryGirl.define do
  factory :goal do
    name { Faker::Name.name }
    content { Faker::Company.bs }
    deadline { Faker::Date.between(1.year.ago, 1.year.from_now )}
    user_id { rand(5) }
    completed { [true, false].sample }
  end
end
