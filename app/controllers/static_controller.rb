class StaticController < ApplicationController
  def services
    authorize :static, :show?
  end
end
