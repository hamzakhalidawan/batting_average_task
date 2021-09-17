class CreateCsvImports < ActiveRecord::Migration[6.1]
  def change
    create_table :csv_imports do |t|
      t.integer :player_id
      t.integer :year_id
      t.integer :stint
      t.integer :team_id
      t.integer :ab
      t.integer :h

      t.timestamps
    end
  end
end
