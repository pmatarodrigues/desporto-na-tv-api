require_relative '../interactors/zapping_interactor'

class ApplicationController < ActionController::API

  def zapping
    zapping_interactor = ZappingInteractor.new
    render json: zapping_interactor.call
  end

  def zapping_today
    zapping_interactor = ZappingInteractor.new
    render json: zapping_interactor.call(today: true)
  end

end
