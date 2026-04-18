class Flow < ApplicationRecord
  enum :status, { draft: "draft", published: "published", archived: "archived" }, default: :draft

  belongs_to :workspace
  belongs_to :current_version

  has_many :flow_versions, dependent: :destroy

  validates :name, presence: true, length: { maximum: 150 }

  scope :drafts, -> { where(status: "draft") }
  scope :published, -> { where(status: "published") }
  scope :archived, -> { where(status: "archived") }
end
