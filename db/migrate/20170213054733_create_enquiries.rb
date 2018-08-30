class CreateEnquiries < ActiveRecord::Migration[5.0]
  def change
    create_table :enquiries do |t|
      t.references :user, foreign_key: true
      t.references :freelancer, foreign_key: true
      t.datetime :start_date
      t.datetime :end_date
      t.string :description
      t.integer :price
      t.string :status, default: 'open'

      t.timestamps
    end
  end
end
