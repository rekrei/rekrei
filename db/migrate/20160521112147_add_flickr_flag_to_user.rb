class AddFlickrFlagToUser < ActiveRecord::Migration
  def change
    add_column :users, :can_flickr, :boolean, default: false
  end
end
