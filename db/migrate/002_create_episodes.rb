class CreateEpisodes < ActiveRecord::Migration
  def self.up
    create_table :episodes do |t|
      t.string :title
      t.string :url
      t.integer :season
      t.integer :episode
      t.text :description
      t.string :release_date
      
      t.references :serie

      t.timestamps null: false
    end
  end

  def self.down
    drop_table :episodes
  end
end
