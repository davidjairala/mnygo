include UsersHelper

class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :checkUserInfo
end
