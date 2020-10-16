require 'typhoeus'

def entities_to_create(model, max_count)
  current = (max_count - model.count)
  current >= 0 ? current : 0
end

# entities_to_create(User, 100).times do
#   User.create(login: SecureRandom.hex(4))
# end

users = User.all

hydra = Typhoeus::Hydra.new(max_concurrency: ENV.fetch("RAILS_MAX_THREADS") { 40 })
entities_to_create(Post, 200_000).times do
  params = {
    title: SecureRandom.hex(4),
    ip: "255.255.255.#{rand(1..50)}",
    content: SecureRandom.hex(50).scan(/.{1,6}/).join(' '),
    author: users.sample.login
  }

  hydra.queue(
    Typhoeus::Request.new(
      "localhost:9292/api/v1/posts",
      followlocation: true,
      body: params,
      method: :post
    )
  )
end
hydra.run
# post_ids = Post.pluck(:id)

# entities_to_create(Rating, 200_000).times do
#   ::Ratings::Create.new({value: rand(1..5), post_id: post_ids.sample}).call
# end
