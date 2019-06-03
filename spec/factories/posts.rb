FactoryBot.define do
  factory :post do
    images { Rack::Test::UploadedFile.new(Rails.root.join('spec/support/image.jpeg'), 'image/jpeg') }
  end
end
