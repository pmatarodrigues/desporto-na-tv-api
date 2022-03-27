require_relative '../interactors/zapping_interactor'

class ApplicationController < ActionController::API

  def zapping
    zapping_interactor = ZappingInteractor.new
    render json: zapping_interactor.call
  end

end
