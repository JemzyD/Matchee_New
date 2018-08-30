class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :phone
      t.string :address
      t.string :profile_picture
      t.integer :email_confirmed, :default => 0
      t.string :confirm_token
      t.integer :reset_confirmed, :default => 0
      t.string :reset_token

      t.timestamps
    end
  end
end
