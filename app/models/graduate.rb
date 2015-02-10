class Graduate < ActiveRecord::Base
  belongs_to :cohort, foreign_key: "dbc_id"
end