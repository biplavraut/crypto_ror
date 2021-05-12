class ChangeExistingColumnFields < ActiveRecord::Migration[6.1]
  def change
    rename_column :messages, :email, :email_ciphertext
    rename_column :messages, :phone, :phone_ciphertext
    rename_column :messages, :message, :message_ciphertext
  end
end
