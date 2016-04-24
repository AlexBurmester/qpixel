module ApplicationHelper
  def get_setting(name)
    begin
      setting = SiteSetting.find_by_name name
      return setting.value
    rescue
      raise ActionController::RoutingError.new('Internal Server Error')
    end
  end
end
