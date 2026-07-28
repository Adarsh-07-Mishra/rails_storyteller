class CreateRepositories < ActiveRecord::Migration[8.0]
  def change
    create_table :repositories do |t|
      t.references :project, null: false, foreign_key: true

      t.string :local_path
      t.string :default_branch
      t.string :head_sha

      t.integer :commit_count, default: 0
      t.integer :repository_size, default: 0

      t.timestamps
    end
  end
end