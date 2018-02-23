class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :login, null: false
      t.string :password_digest, null: false

      t.string :name

      t.integer :role, index: true, default: 0, null: false

      t.timestamps

      t.index :login, unique: true
    end
  end
end
