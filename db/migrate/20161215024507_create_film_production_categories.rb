class CreateFilmProductionCategories < ActiveRecord::Migration
  def change
    create_table :film_production_categories do |t|
      t.string :name
      t.string :description

      t.timestamps null: false
    end
  end
end
