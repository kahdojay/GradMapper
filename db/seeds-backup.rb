include CohortSeeder
include GraduateSeeder

DBC.token = ENV["DBC_KEY"]
cohorts = DBC::Cohort.all
alumn_cohorts = cohorts.select { |c| (c.in_session == false) && (Time.parse(c.start_date) < Time.now) }
graduates = alumn_cohorts.collect { |c| c.students }.flatten

CohortSeeder::seed(alumn_cohorts)
GraduateSeeder::seed(graduates)