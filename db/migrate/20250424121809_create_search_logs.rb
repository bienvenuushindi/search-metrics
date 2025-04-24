class CreateSearchLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :search_logs do |t|
      t.string :ip_address
      t.references :search_query, null: false, foreign_key: true
      t.integer :results_count

      t.timestamps
    end
  end
end
