class CreateIssues < ActiveRecord::Migration[5.1]
  def change
    create_table :issues do |t|
      t.string :title, null: false

      t.integer :status, default: 0, null: false, index: true

      t.references :author, index: true, null: false, foreign_key: { to_table: :users }
      t.references :manager, index: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
