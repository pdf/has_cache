Fabricator(:comment) do
  content { Faker::Lorem.sentence }
  user    { Fabricate(:user) }
  article { Fabricate(:article) }
end
