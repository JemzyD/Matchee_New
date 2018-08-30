class AddExperienceToFreelancers < ActiveRecord::Migration[5.0]
  def change
    add_column :freelancers, :experience, :string
  end
end
