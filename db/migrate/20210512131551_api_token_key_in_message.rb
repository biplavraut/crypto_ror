class ApiTokenKeyInMessage < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :key, :text
  end
end
