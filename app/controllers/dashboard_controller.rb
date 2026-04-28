class DashboardController < ApplicationController
  def index
    render inertia: {
      workspaces: Current.user.workspaces.order(created_at: :desc).as_json(only: %i[id name created_at updated_at]),
      user: {
        id: Current.user.id,
        name: Current.user.name,
        email: Current.user.email
      }
    }
  end

  def create
    workspace = Current.user.owned_workspaces.new(workspace_params)

    ActiveRecord::Base.transaction do
      workspace.save!
      workspace.workspace_memberships.create!(
        user: Current.user,
        role: "owner"
      )
    end

    redirect_to workspaces_path, notice: "Workspace criado com sucesso"
  rescue ActiveRecord::RecordInvalid
    redirect_to workspace_path, inertia: {
      errors: workspace.errors
    }
  end
end
