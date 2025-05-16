# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Cleaning up database..."

Reward.destroy_all
Transaction.destroy_all
User.destroy_all

puts "Seeding users with transactions and rewards..."

users = 5.times.map do
  User.create!(
    email: Faker::Internet.unique.email,
    password: "password123",
    date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 45),
    country: Faker::Address.country,
    jti: SecureRandom.uuid
  )
end

users.each do |user|
  rand(2..4).times do
    user.transactions.create!(
      amount: rand(20.0..500.0).round(2),
      country: user.country,
      status: :processed,
      created_at: Faker::Date.backward(days: 60)
    )
  end

  rand(1..3).times do
    user.rewards.create!(
      reward_type: %w[free_coffee free_movie_tickets].sample,
      message: %w[birthday monthly_points new_user_spend].sample,
      issued_on: Faker::Date.backward(days: 30)
    )
  end
end

puts "✅ Done seeding!"
