class CreateProjects < ActiveRecord::Migration[8.0]
   def change
    create_table :projects do |t|
      t.string :name, null: false
      t.string :github_url, null: false
      t.string :default_branch
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    add_index :projects, :github_url, unique: true
  end
end
