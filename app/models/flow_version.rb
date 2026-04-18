class FlowVersion < ApplicationRecord
  belongs_to :flow
  belongs_to :created_by, class_name: "User", optional: true

  has_many :steps, -> { order(:position, :id) }, dependent: :destroy

  validates :version_number, presence: true, numericality: { only_integer: true, greater_than: 0 }, uniqueness: { scope: :flow_id }
  validates :definition_json, presence: true

  scope :published, -> { where.not(published_at: nil) }
  scope :drafts, -> { where(published_at: nil) }

  def published?
    published_at.present?
  end
end
