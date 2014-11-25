class VideoDecorator < Draper::Decorator
  delegate_all

  def display_rating(rating)
    if rating.present?
      "Rating: #{sprintf '%.1f', rating}/5.0"
    end
  end

end
