FactoryGirl.define do
  factory :product do
    sequence(:name)  {|n| "prodcut#{n}"}
    sequence(:description) {|n| "blahblahblah"}
    sequence(:kind) {|n| 'SERVICE'}
    sequence(:cover) {|n| File.new File.join(Rails.root, 'public/default_avatars/tiny.png') }
  end
end