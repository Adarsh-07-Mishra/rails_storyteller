class AddArchitectureFieldsToCommits < ActiveRecord::Migration[8.0]
  def change
    add_column :commits, :architecture_change, :boolean, default: false, null: false
    add_column :commits, :change_summary, :json, default: {}
  end
end