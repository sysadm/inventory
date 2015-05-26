FactoryGirl.define do

  factory :inventory do
    sequence(:tag) {|n| "tag#{n}" }
    sequence(:model){|n| "model#{n}" }
    sequence(:serial){|n| "serial#{n}" }
    sequence(:notes){|n| "notes#{n}" }
    date_of_purchase Time.now.to_date
    date_of_registration Time.now.to_date
    user User.last
    kind Kind.last
    vendor Vendor.last
  end
end
