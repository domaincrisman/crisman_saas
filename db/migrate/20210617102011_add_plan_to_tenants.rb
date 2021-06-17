class AddPlanToTenants < ActiveRecord::Migration[6.0]
  def change
    add_column :tenants, :plan, :string, null: false, default: "solo"
    #Ex:- :null => false
    add_index :tenants, :plan
  end
end
