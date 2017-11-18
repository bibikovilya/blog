POST_COUNT = 200
USER_COUNT = 100
IP_COUNT = 50
RATE_COUNT = 150

users_ids = (1..USER_COUNT).to_a
ips = (1..IP_COUNT).to_a

POST_COUNT.times do |i|
  PostServices::Create.new(title: "Title#{i}",
                           body: "Body##{i}",
                           login: "user##{users_ids.sample}",
                           ip: "128.0.0.#{ips.sample}").call
end

post_ids = Post.pluck(:id)

RATE_COUNT.times do
  PostServices::AddMark.new(post_id: post_ids.sample, mark: rand(1..5)).call
end
