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
      t.boolean :valid_linked_in?, {default: false}
      t.integer :dbc_id, {default: "unknown"}
      t.string  :city, {default: "city unknown"}
      t.string  :state_or_country
      t.string  :company, {default: "company unknown"}
      t.string  :lat, {default: "unknown"}
      t.string  :long, {default: "unknown"}
      t.string  :img_url
      t.string  :cohort_name, {default: "unknown"}
    end
  end
end
