def entities_to_create(model, max_count)
  current = (max_count - model.count)
  current >= 0 ? current : 0
end

entities_to_create(User, 100).times do
  User.create(login: SecureRandom.hex(4))
end

user_ids = User.pluck(:id)

entities_to_create(Post, 200_000).times do
  Post.create(
    title: SecureRandom.hex(4),
    ip: "255.255.255.#{rand(1..50)}",
    content: SecureRandom.hex(50).scan(/.{1,6}/).join(' '),
    user_id: user_ids.sample
  )
end
