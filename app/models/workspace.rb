class Workspace < ApplicationRecord
  belongs_to :owner, class_name: "User"

  has_many :workspace_memberships, dependent: :destroy
  has_many :members, through: :workspace_memberships, source: :user
  has_many :flows, dependent: :destroy

  validates :name, presence: true, length: { maximum: 120 }

  after_create :ensure_owner_membership!

  private

  def ensure_owner_membership!
    workspace_memberships.find_or_create_by!(user: owner) do |membership|
      membership.role = "owner"
    end
  end
end
