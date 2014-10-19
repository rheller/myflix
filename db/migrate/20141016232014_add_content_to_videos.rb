class AddContentToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :content, :string
  end
end
