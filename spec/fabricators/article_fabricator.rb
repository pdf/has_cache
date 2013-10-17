Fabricator(:article) do
  title { Faker::Company.catch_phrase }
  body { Faker::Lorem.sentences.join }
  user { Fabricate(:user) }
end
