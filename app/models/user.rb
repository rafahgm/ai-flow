class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :owned_workspaces, class_name: "Workspace", foreign_key: :owner_id, dependent: :nullify
  has_many :workspace_memberships, dependent: :destroy
  has_many :workspaces, through: :workspace_memberships
  has_many :created_flow_versions, class_name: "FlowVersion", foreign_key: :created_by_id, dependent: :nullify


  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
