class CreateCohorts < ActiveRecord::Migration
  def change
    create_table :cohorts do |t|
      t.string   :name
      t.string   :email
      t.string   :location
      t.datetime :start_date
      t.integer  :dbc_id
    end
  end
end
