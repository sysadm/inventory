FactoryGirl.define do

  factory :user do
    sequence(:username) {|n| "username#{n}" }
    sequence(:name){|n| "name#{n}" }
    sequence(:first_name){|n| "first_name#{n}" }
    sequence(:last_name){|n| "last_name#{n}" }
    sequence(:email) {|n| "example#{n}@test.com" }
    department Department.last
    factory :login_user do
      login true
      admin false
    end
    factory :admin_user do
      admin true
      login false

    end
    factory :admin_login_user do
      login true
      admin true
    end
    factory :default_user do
      login false
      admin false
    end
  end
end
