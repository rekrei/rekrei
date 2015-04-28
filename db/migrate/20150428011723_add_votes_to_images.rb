class AddVotesToImages < ActiveRecord::Migration
  def change
    add_column :assets, :votes, :integer, default: 0, min: 0
  end
end
