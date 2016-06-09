99.times do |n|
  first_name  = Faker::Name.first_name
  last_name  = Faker::Name.last_name
  age = Faker::Number.between(18, 28)
  city = Faker::Address.city
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(first_name:  first_name,
  				last_name:  last_name,
  				age: age,
  				city: city,
               email: email,
               password:              password,
               password_confirmation: password)
end