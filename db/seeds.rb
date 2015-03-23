DBC.token = ENV["DBC_KEY"]
cohorts = DBC::Cohort.all
# alum_cohorts = cohorts.select { |c| (c.in_session == false) && (Time.parse(c.start_date) < Time.now) }
# cohorts.each {|c| p c.name}
Cohort.seed(cohorts)
cohorts_to_destroy = ["Friends of DBC", "Dummy Cohort", "Testy McTest", "Test cohort", "Chicago - On Hold", "SF - On Hold", "NYC - On Hold", "Fall 2012 Waiting List", "Staff Phase 0", "CTD - Project Chicago"]
cohorts_to_destroy.each do |cohort_name|
  cohort_to_destroy = Cohort.find_by(name: cohort_name)
  cohort_to_destroy.graduates.each {|graduate| graduate.destroy}
  cohort_to_destroy.destroy
end