module DBCSeeder
  def self.seed(cohorts)
    cohorts.each do |c|
      Cohort.create!(
        name: c.name,
        email: c.email,
        location: c.location,
        start_date: c.start_date,
        dbc_id: c.id
      )
      c.students.each do |g|
        Graduate.create!(
          cohort_name: c.name,
          name: g.name,
          email: g.email,
          github: g.profile[:github],
          quora: g.profile[:quora],
          twitter: g.profile[:twitter],
          facebook: g.profile[:facebook],
          linked_in: g.profile[:linked_in],
          dbc_id: g.cohort_id
        )
      end
    end
  end
end
