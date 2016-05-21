class AddFlickrTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :flickr_oauth_token, :string
    add_column :users, :flickr_oauth_secret, :string
  end
end
