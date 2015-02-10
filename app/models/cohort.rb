class Cohort < ActiveRecord::Base
  has_many :graduates, primary_key: "dbc_id", foreign_key: "dbc_id"
end