FactoryGirl.define do

  factory :kind do
    sequence(:description) {|n| "desc#{n}" }
  end
end
