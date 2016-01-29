# cf https://robots.thoughtbot.com/data-migrations-in-rails

# This is only meant to be run once, to update all existing questions
# whose authors had not voted for them yet; this step is note needed
# for questions created after the changes to questions#create which
# automatically vote up new questions as they're created (commit
# 1159dfe57a5dfaba8bee4d42912823a765973da0).

namespace :temporary do
  desc "Updates existing questions with a default vote from their authors."
  task update_question_author_votes: :environment do
    users = User.includes(:questions).all
    puts "Updating #{Question.count} questions for #{users.count} users: "

    ActiveRecord::Base.transaction do
      users.each do |user|
        user.questions.each do |q|
          user.vote_exclusively_for(q)
          print '.'
        end
      end
    end

    puts "\nUpdated!"
  end
end