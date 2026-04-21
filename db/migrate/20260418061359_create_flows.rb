class CreateFlows < ActiveRecord::Migration[8.1]
  def change
    create_table :flows do |t|
      t.references :workspace, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.string :status, null: false, default: "draft"

      t.timestamps
    end
    add_index :flows, :status
    add_index :flows, [ :workspace_id, :name ]
  end
end
