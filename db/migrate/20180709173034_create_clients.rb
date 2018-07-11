class CreateClients < ActiveRecord::Migration[5.2]
  def change
    create_table :clients do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.timestamps
    end

    add_index :clients, :email, unique: true
  end
end
