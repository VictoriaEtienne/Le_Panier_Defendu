class HistoriesController < ApplicationController
  def index
    @histories = History.all
  end

  def show
    @history = History.find(params[:id])
  end

  def destroy
    @history = History.find(params[:id])
    @history.destroy
    redirect_to histories_path
  end
end