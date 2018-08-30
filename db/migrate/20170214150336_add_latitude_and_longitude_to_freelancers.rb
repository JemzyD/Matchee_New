class AddLatitudeAndLongitudeToFreelancers < ActiveRecord::Migration[5.0]
  def change
    add_column :freelancers, :latitude, :string
    add_column :freelancers, :longitude, :string
  end
end
