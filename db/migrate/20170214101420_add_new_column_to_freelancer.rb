class AddNewColumnToFreelancer < ActiveRecord::Migration[5.0]
  def change
    add_column :freelancers, :capacity, :integer
  end
end
