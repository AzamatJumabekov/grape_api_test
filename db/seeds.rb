require 'typhoeus'

def hydra_instance
  Typhoeus::Hydra.new(max_concurrency: ENV.fetch("RAILS_MAX_THREADS") { 40 })
end

def add_to_queue(hydra, endpoint, params)
  url = 'localhost:9292'
  full_url = url + endpoint
  hydra.queue(
    Typhoeus::Request.new(
      full_url,
      followlocation: true,
      body: params,
      method: :post
    )
  )
end

def entities_to_create(model, max_count)
  current = (max_count - model.count)
  current >= 0 ? current : 0
end

def create_users
  hydra = hydra_instance
  entities_to_create(User, 100).times do
    params = { login: SecureRandom.hex(4) }
    add_to_queue(hydra, '/api/v1/users', params)
  end
  hydra.run
end


def create_posts
  users = User.all
  hydra = hydra_instance
  entities_to_create(Post, 200_000).times do
    params = {
      title: SecureRandom.hex(4),
      ip: "255.255.255.#{rand(1..50)}",
      content: SecureRandom.hex(50).scan(/.{1,6}/).join(' '),
      author: users.sample.login
    }
    add_to_queue(hydra, '/api/v1/posts', params)
  end
  hydra.run
end

def create_ratings
  hydra = hydra_instance
  post_ids = Post.pluck(:id)
  entities_to_create(Rating, 100_000).times do
    params = { value: rand(1..5), post_id: post_ids.sample }
    add_to_queue(hydra, '/api/v1/ratings', params)
  end
  hydra.run
end

create_users
create_posts
create_ratings
