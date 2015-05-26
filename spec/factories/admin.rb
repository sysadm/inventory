FactoryGirl.define do

  factory :admin do
    sequence(:email) {|n| "example#{n}@test.com" }
    password 'secret'
  end
end
