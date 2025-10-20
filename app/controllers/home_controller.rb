class HomeController < ApplicationController
  def index
  end

  def storage
    kind = ProfileImageUploader.new.send(:storage).class.name
    render plain: kind
  end
end
