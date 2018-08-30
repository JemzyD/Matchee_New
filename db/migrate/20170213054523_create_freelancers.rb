class CreateFreelancers < ActiveRecord::Migration[5.0]
  def change
    create_table :freelancers do |t|
      t.string :profession
      t.text :description
      t.datetime :start_working_hours
      t.datetime :end_working_hours
      t.text :picture
      t.references :user, foreign_key: true
      t.integer :price_start
      t.integer :price_end

      t.timestamps
    end
  end
end
