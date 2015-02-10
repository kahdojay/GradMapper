class CreateGraduates < ActiveRecord::Migration
  def change
    create_table :graduates do |t|
      t.string  :name
      t.string  :email
      t.string  :github
      t.string  :quora
      t.string  :twitter
      t.string  :facebook
      t.string  :linked_in
      t.integer :dbc_id
    end
  end
end
