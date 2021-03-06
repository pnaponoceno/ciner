class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :original_title
      t.string :title
      t.integer :year
      t.string :length
      t.text :synopsis
      t.date :release
      t.date :brazilian_release
      t.references :city
      t.references :state
      t.references :country
      t.references :age_range

      t.string :cover

      t.references :studio

      t.timestamps null: false
    end
  end
end
