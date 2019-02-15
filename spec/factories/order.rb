FactoryBot.define do
  factory :order do
    user
    status { 0 }
  end
end
