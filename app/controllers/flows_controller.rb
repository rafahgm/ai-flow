class FlowsController < ApplicationController
  before_action :set_workspace
  def index
    @flows = Current.user.workspaces.flows.order(created_at: :desc)
    render inertia: {
      flows: @flows.as_json(only: %i[id name description status created_at updated_at])
    }
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
  private
  def set_workspace
  end
end
