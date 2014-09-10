class QueueItemsController < ApplicationController
  before_filter :logged_in?

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find_by_id(params[:video_id])
    QueueItem.create(video: video, user: current_user, position: current_user.queue_items.count + 1) unless queued_video_for_current_user?(video)
    redirect_to my_queue_path
  end
  
  def update
    @queue_items = params[:queue_items]
    if !update_all_queue_items params[:queue_items]
      flash[:errors] = "Could not save!"
    end

    redirect_to my_queue_path
  end
  
  def destroy
    qi = QueueItem.find_by_id(params[:id])
    qi.destroy unless (qi.blank? || qi.user != current_user )
    normalize_positions
    redirect_to my_queue_path
  end

private

  def queued_video_for_current_user? video
    QueueItem.where(video_id: video.id, user_id: current_user.id).count > 0
  end

  def update_all_queue_items qi

#the position in the parameters just gives the relative order
#have the actual order start with one and proceed up
    sorted_qi = qi.sort{|a,b| a[:position].to_i <=> b[:position].to_i}

    #wrap in transaction because positions are related to each other
    begin
      ActiveRecord::Base.transaction do
        next_position = 1
        sorted_qi.each do |q|
          queue_item = current_user.queue_items.select{|i| q[:id] == i.id.to_s}
          if queue_item.first.present?
            queue_item.first.position = next_position
            next_position+= 1
            queue_item.first.save!
          else
            #if item doesn't belong to user, roll back everything
#            raise ActiveRecord::Rollback
#record not found rolls back and also needs to be rescued
            raise ActiveRecord::RecordNotFound
          end
        end
      end
    rescue ActiveRecord::RecordNotFound
      return false
    end
    return true
  end    

  def normalize_positions
    current_user.queue_items.each_with_index do |q, i|
      # index starts at 0, position at 1
      q.update_attributes(position: i + 1)
    end

  end

end
