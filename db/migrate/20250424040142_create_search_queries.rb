class CreateSearchQueries < ActiveRecord::Migration[8.0]
  def change
    create_table :search_queries do |t|
      t.text :query
      t.integer :count, default: 0

      t.timestamps
    end
  end
end
