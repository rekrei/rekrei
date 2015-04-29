class AddSlugToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :slug, :string
  end
end
