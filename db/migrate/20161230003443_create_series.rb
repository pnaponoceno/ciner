class CreateSeries < ActiveRecord::Migration
  def change
    create_table :series do |t|
      t.string :original_title
      t.string :title
      t.integer :start_year
      t.integer :finish_year
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

      # Serie

      t.integer :number_episodes
      t.integer :aired_episodes

      t.timestamps null: false
    end
  end
end
