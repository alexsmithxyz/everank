class CreateTitles < ActiveRecord::Migration[8.0]
  def change
    create_table :titles do |t|
      t.string :name
      t.date :date_available
      t.text :description

      t.timestamps
    end
  end
end
