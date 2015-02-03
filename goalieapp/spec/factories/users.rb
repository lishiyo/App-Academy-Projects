FactoryGirl.define do

  factory :user do
    username "test_user"
    password "password"

    sequence :goals do |g|
      FactoryGirl.create(:goals, name: "first goal", content: "my first goal", deadline: "2014-12-25")
    end
  end

end
