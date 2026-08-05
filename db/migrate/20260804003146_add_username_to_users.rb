class AddUsernameToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :username, :string, null: false

    add_index :users,
              "LOWER(username)",
              unique: true,
              name: "index_users_on_lower_username"
  end
end