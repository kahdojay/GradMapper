module GraduateSeeder
  def self.seed(graduates)
    graduates.each do |g|
      Graduate.create!(
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
