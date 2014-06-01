class CreateStageIntegrations < ActiveRecord::Migration
  def change
    create_table :stage_integrations do |t|
      t.integer :stage_id
      t.integer :integration_id
      t.text :config
    end
  end
end
