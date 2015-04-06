namespace :db do
  desc "Load canned data into the database"
  task :canned => :environment do
    load "#{Rails.root}/db/canned/canned.rb"
  end
end