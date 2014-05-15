# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :picture do
    user nil
    image "MyString"
    name "MyString"
    description "MyText"
  end
end
