class CreateVenues < ActiveRecord::Migration[5.0]
  def change
    create_table :venues do |t|
      t.string :name
      t.text :description
      t.integer :category
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
