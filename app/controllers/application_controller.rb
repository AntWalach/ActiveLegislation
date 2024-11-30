class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    before_action :https_redirect
    before_action :set_notification_exception
    before_action :set_notifications
    layout :layout_by_resource


    if Rails.env.production?
      rescue_from ActionController::RoutingError, ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound do |exception|
        render_error 404, exception
      end

      rescue_from Exception do |exception|
        ExceptionNotifier.notify_exception(exception,:env => request.env, :data => {:message => "Błąd nieprzechwycony"})
        render_error 500, exception
      end
  
      rescue_from CanCan::AccessDenied do |exception|
        if current_user
          render_error 403, exception
        else
          redirect_to authenticated_root_path
        end
      end
    end

    protected


    def set_locale
      if params[:locale]
        cookies[:locale] = params[:locale]
        I18n.locale = params[:locale]
      elsif cookies[:locale]
        I18n.locale = cookies[:locale]
      else
        I18n.locale = I18n.default_locale
      end
    end

    def default_url_options
      { locale: I18n.locale }
    end

    def set_notification_exception
      request.env['exception_notifier.exception_data'] = {"server" => request.env['SERVER_NAME']}
      # can be any key-value pairs
    end
 
    def render_error(status, exception)
      logger.error exception.message
      logger.error exception.backtrace.join("\n")
 
      respond_to do |format|
        format.html { render template: "errors/error_#{status}", layout: 'layouts/application', status: status }
        # format.all { render nothing: true, status: status }
      end
    end

    def layout_by_resource
        if user_signed_in?
          'with_menus'
        elsif params[:controller].in?(['main', 'articles'])
          'application'
        else
          'sessions'
        end
    end

    def https_redirect
      if Rails.env.production?
        if request.ssl? && !use_https? || !request.ssl? && use_https?
          protocol = request.ssl? ? "http" : "https"
          flash.keep
          redirect_to protocol: "#{protocol}://", status: :moved_permanently
        end
      end
    end
  
    def use_https?
      true 
    end

    def set_admin_menu
      @admin_menu = true
      # @first_breadcrumb = I18n.t(:admin_zone)  
    end

    protected
    
    def authenticate_official!
      redirect_to authenticated_root_path, alert: 'Brak dostępu' unless current_user.is_a?(Official) || current_user.is_a?(Admin)
    end

    private

    def set_notifications
      if user_signed_in?
        @notifications = current_user.notifications.unread.order(created_at: :desc)
      else
        @notifications = []
      end
    end
end
