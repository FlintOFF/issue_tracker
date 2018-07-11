class CreateIssues < ActiveRecord::Migration[5.2]
  def change
    create_table :issues do |t|
      t.string :title
      t.string :body
      t.references :client, foreign_key: true
      t.references :manager, foreign_key: true
      t.column :status, :integer, default: 0
      t.timestamps
    end
  end
end
