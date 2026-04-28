class WorkspacesController < ApplicationController
  def index
    render inertia: {}
  end

  def create
    workspace = Current.user.owned_workspaces.new(workspace_params)

    ActiveRecord::Base.transaction do
      workspace.save!
      workspace.workspace_memberships.create!(
        user: Current.user,
        role: :owner
      )
    end

    redirect_to workspaces_path, notice: "Workspace criado com sucesso!"

  rescue ActiveRecord::RecordInvalid
    redirect_to workspaces_path, inertia: {
      errors: workspace.errors
    }
  end

  private

  def workspace_params
    params.require(:workspace).permit(:name)
  end
end
