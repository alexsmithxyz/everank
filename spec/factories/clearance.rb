FactoryBot.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user do
    email
    password { SecureRandom.alphanumeric }
    role { :ordinary_user }
  end
end
