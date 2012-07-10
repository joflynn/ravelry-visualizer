class VisualizeController < ApplicationController
  # GET /visualizes
  # GET /visualizes.json
  def index
    @accounts = Account.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @accounts }
    end
  end

  # GET /visualizes/1
  # GET /visualizes/1.json
  def show
    @account = Account.find_by_username(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @account }
    end
  end
end
