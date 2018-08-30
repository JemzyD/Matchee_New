class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.string :content
      t.boolean :read, :default => false
      t.references :enquiry, foreign_key: true
      t.references :sender, index: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
