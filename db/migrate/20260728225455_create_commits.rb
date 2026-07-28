class CreateCommits < ActiveRecord::Migration[8.0]
  def change
    create_table :commits do |t|
      t.references :repository, null: false, foreign_key: true

      t.string :sha, null: false
      t.string :author_name
      t.string :author_email
      t.text :message

      t.datetime :committed_at, null: false

      t.timestamps
    end

    add_index :commits, :sha
    add_index :commits, :committed_at
  end
end