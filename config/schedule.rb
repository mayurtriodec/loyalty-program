# frozen_string_literal: true

# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Learn more: http://github.com/javan/whenever

# Log output of cron jobs
set :output, "log/cron.log"

# Ensure the correct Ruby version and bundler are used
env :PATH, ENV["PATH"]

# Set the time zone explicitly (e.g., UTC)
env :TZ, "UTC"

# Birthday rewards (runs on 1st day of month)
every "30 23 1 * *" do
  rake "rewards:birthday", output: {
    standard: "log/birthday_rewards.log",
    error: "log/birthday_rewards_error.log"
  }
end

# Monthly points (runs 28th-31st at 11:30 PM)
every "30 23 28-31 * *" do
  rake "rewards:monthly_points", output: {
    standard: "log/monthly_points_rewards.log",
    error: "log/monthly_points_rewards_error.log"
  }
end
