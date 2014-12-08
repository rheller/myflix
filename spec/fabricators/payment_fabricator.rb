Fabricator(:payment) do
  amount {1 + rand(5)}
  reference_id {Faker::Lorem.words(10).join(" ")}
  user
end
