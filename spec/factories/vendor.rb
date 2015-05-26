FactoryGirl.define do

  factory :vendor do
    sequence(:title) {|n| "title#{n}" }
  end
end
