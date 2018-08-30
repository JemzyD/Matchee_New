class CreateRatings < ActiveRecord::Migration[5.0]
  def change
    create_table :ratings do |t|
      t.integer :professionalism
      t.integer :value
      t.integer :cleanliness
      t.text :description_of_job
      t.references :user, foreign_key: true
      t.references :freelancer, foreign_key: true

      t.timestamps
    end
  end
end
