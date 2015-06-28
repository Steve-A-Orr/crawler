class CreateSeries < ActiveRecord::Migration
  def self.up
    create_table :series do |t|
      t.string :name, null: false
      t.string :url
      t.text :description
      t.integer :seasons

      t.timestamps null: false
    end
  end

  def self.down
    drop_table :series
  end
end
