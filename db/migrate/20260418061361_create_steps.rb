class CreateSteps < ActiveRecord::Migration[8.1]
  def change
    create_table :steps do |t|
      t.references :flow_version, null: false, foreign_key: true
      t.string :key, null: false
      t.string :name, null: false
      t.string :type, null: false
      t.integer :position, null: false
      t.jsonb :config_json, null: false, default: {}

      t.timestamps
    end

    add_index :steps, [ :flow_version_id, :key ], unique: true
    add_index :steps, [ :flow_version_id, :position ]
    add_index :steps, :type
  end
end
