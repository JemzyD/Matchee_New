class AddAddressToFreelancers < ActiveRecord::Migration[5.0]
  def change
    add_column :freelancers, :address, :string
  end
end
