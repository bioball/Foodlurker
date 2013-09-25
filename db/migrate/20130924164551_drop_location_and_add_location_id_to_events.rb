class DropLocationAndAddLocationIdToEvents < ActiveRecord::Migration
  def up
    remove_column :events, :location
    add_column :events, :location_id, :integer
  end

  def down
    remove_column :events, :location_id
    add_column :events, :location, :string
  end
end
