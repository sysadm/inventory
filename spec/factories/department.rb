FactoryGirl.define do

  factory :department do
    sequence(:title) {|n| "title#{n}" }
  end
end
