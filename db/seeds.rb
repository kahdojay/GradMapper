include DBCSeeder

DBC.token = ENV["DBC_KEY"]
cohorts = DBC::Cohort.all
alum_cohorts = cohorts.select { |c| (c.in_session == false) && (Time.parse(c.start_date) < Time.now) }
DBCSeeder::seed(alum_cohorts)