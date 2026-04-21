class CreateFlowVersions < ActiveRecord::Migration[8.1]
  def change
    create_table :flow_versions do |t|
      t.references :flow, null: false, foreign_key: true
      t.integer :version_number, null: false
      t.jsonb :definition_json, null: false, default: {}
      t.datetime :published_at
      t.references :created_by, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :flow_versions, [ :flow_id, :version_number ], unique: true
    add_index :flow_versions, :published_at
  end
end
