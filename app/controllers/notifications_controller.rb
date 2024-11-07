class NotificationsController < ApplicationController
  def mark_as_read
    notification = Notification.find(params[:id])
    notification.update(read: true)
    redirect_to request.referer || root_path, notice: 'Powiadomienie oznaczone jako przeczytane.'
  end


end
