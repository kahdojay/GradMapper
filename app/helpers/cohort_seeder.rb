module CohortSeeder
  def self.seed(cohorts)
    cohorts.each do |c|
      Cohort.create!(
        name: c.name,
        email: c.email,
        location: c.location,
        start_date: c.start_date,
        dbc_id: c.id
      )
    end
  end
end
