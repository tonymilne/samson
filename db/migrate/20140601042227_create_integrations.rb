class CreateIntegrations < ActiveRecord::Migration
  def change
    create_table :integrations do |t|
      t.string :identifier
      t.text :config
      t.boolean :enabled
    end
  end
end
