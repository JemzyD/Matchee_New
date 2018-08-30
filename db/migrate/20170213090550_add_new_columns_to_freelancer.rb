class AddNewColumnsToFreelancer < ActiveRecord::Migration[5.0]
  def change
    add_column :freelancers, :schedule, :text
  end
end
