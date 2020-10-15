FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "Title #{n}" }
    content { SecureRandom.hex(50).scan(/.{1,6}/).join(' ') }
    ip      { "255.255.255.#{rand(1..50)}" }

    association :user, factory: :user
  end
end
