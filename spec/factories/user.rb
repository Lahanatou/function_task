FactoryBot.define do
  factory :user do
    name { 'name' }
    email { 'user@gmail.com' }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
