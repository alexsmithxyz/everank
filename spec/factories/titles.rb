FactoryBot.define do
  sequence :name do |n|
    "Title ##{n}"
  end

  factory :title do
    name
    date_available { '2025-09-01' }
    description { 'Here is the title description.' }
  end
end
