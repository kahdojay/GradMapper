include DBCSeeder
# include GraduateSeeder

DBC.token = ENV["DBC_KEY"]
cohorts = DBC::Cohort.all
alum_cohorts = cohorts.select { |c| (c.in_session == false) && (Time.parse(c.start_date) < Time.now) }
# graduates = alum_cohorts.collect { |c| c.students }.flatten

DBCSeeder::seed(alum_cohorts)
# GraduateSeeder::seed(graduates)

# cohorts.each do |cohort|
#   cohort.students.each do |student|
#     target_name = student.name
#     Student.find_by(name: target_name).update(cohort: cohort)
#   end
# end