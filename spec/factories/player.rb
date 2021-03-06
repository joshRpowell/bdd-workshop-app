FactoryBot.define do
  factory :player do
    handle { 'LOGO' }
    name { 'Cynthia Solomon' }
    email { 'cynthia@logo.com' }
    avatar_url { '/sample_avatars/logo_terrapin.png' }
  end
end
