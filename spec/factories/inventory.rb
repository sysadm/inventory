FactoryGirl.define do

  factory :inventory do
    sequence(:tag) {|n| "tag#{n}" }
    sequence(:model){|n| "model#{n}" }
    sequence(:serial){|n| "serial#{n}" }
    sequence(:notes){|n| "notes#{n}" }
    date_of_purchase Time.now.to_date
    date_of_registration Time.now.to_date
    factory :inventory_old do
      user User.first
      kind Kind.last
      vendor Vendor.last
    end
    factory :inventory_new do
      user
      kind
      vendor
    end
    factory :for_sort_inventory do
      tag 't'
      model 't'
      user
      kind
      vendor
    end
  end
end
