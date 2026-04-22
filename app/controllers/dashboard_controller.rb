class DashboardController < ApplicationController
  def index
    render inertia: {
      user: {
        id: Current.user.id,
        name: Current.user.name,
        email: Current.user.email
      }
    }
  end
end
