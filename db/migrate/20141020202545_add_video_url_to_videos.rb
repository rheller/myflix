class AddVideoUrlToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :video_url, :string
    remove_column :videos, :content
  end
end
