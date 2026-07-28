class CreateCommitFiles < ActiveRecord::Migration[8.0]
  def change
    create_table :commit_files do |t|
      t.references :commit, null: false, foreign_key: true

      t.string :path, null: false
      t.integer :change_type, null: false

      t.integer :additions, default: 0
      t.integer :deletions, default: 0

      t.timestamps
    end

    add_index :commit_files, :path
  end
end