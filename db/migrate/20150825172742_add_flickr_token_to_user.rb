class AddFlickrTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :flickr_token, :string
  end
end
