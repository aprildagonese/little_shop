FactoryBot.define do
  factory :order do
    user
    activation_status { 0 }
  end
end
