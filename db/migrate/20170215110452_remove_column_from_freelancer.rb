class RemoveColumnFromFreelancer < ActiveRecord::Migration[5.0]
  def change
    remove_column :freelancers, :capacity, :integer
  end
end
