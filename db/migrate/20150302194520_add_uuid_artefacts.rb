class AddUuidArtefacts < ActiveRecord::Migration
  def change
    add_column :artefacts, :uuid, :string
    add_index :artefacts, :uuid
  end
end
