# frozen_string_literal: true

namespace :rewards do
  desc "Check birthday rewards (monthly)"
  task birthday: :environment do
    users = User.where(
      "CAST(STRFTIME('%m', date_of_birth) AS INTEGER) = ?",
      Date.current.month
    )

    process_batch(users, Rewards::BirthdayRewardService)

    puts "[#{Time.current}] Birthday rewards completed."
  end

  desc "Check monthly points rewards (monthly)"
  task monthly_points: :environment do
    users = User.joins(:transactions)
                .where(transactions: {
                  status: :processed,
                  created_at: Date.current.all_month
                })
                .distinct

    process_batch(users, Rewards::MonthlyPointsRewardService)

    puts "[#{Time.current}] Monthly points rewards completed."
  end

  def process_batch(users, service)
    processed = 0
    errors = 0

    users.find_each(batch_size: 1000) do |user|
      begin
        service.call(user)
        processed += 1
      rescue StandardError => e
        errors += 1
      end
    end

    puts "Processed: #{processed}, Errors: #{errors}"
    processed
  end
end
