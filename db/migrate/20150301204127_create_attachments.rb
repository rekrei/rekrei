class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :attachment_type
      t.belongs_to :artefact, index: true

      t.timestamps null: false
    end
  end
end
