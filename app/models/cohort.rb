class Cohort < ActiveRecord::Base
  has_many :graduates, foreign_key: "dbc_id"
end