class CreateGraduates < ActiveRecord::Migration
  def change
    create_table :graduates do |t|
      t.string  :name, {default: "unknown"}
      t.string  :email, {default: "unknown"}
      t.string  :github, {default: "unknown"}
      t.string  :quora, {default: "unknown"}
      t.string  :twitter, {default: "unknown"}
      t.string  :facebook, {default: "unknown"}
      t.string  :linked_in, {default: "unknown"}
      t.integer :dbc_id, {default: "unknown"}
      t.string  :location, {default: "unknown"}
      t.string  :company, {default: "company unknown"}
      t.string  :lat, {default: "unknown"}
      t.string  :long, {default: "unknown"}
      t.string  :img_url, {default: "unknown"}
      t.string  :cohort_name, {default: "unknown"}
    end
  end
end
