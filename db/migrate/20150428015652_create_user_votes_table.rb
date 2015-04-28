class CreateUserVotesTable < ActiveRecord::Migration
  def change
    create_table :user_votes do |t|
      t.integer :user_id
      t.integer :asset_id
      t.string :direction
    end
  end
end
