class CreateEvents < ActiveRecord::Migration
  def up
    create_table :events do |t|
      t.string :name
      t.string :location
      t.string :description
      t.datetime :starttime
      t.datetime :endtime
      t.timestamps
    end
  end

  def down
    drop_table :events
  end
end
