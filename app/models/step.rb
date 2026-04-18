class Step < ApplicationRecord
  enum :type, { llm_prompt: "llm_prompt", web_search: "web_search", transform: "transform", condition: "condition", http_request: "" }

  belongs_to :flow_version

  validates :key, presence: true, format: { with: /\A[a-z0-9_]+\z/, message: "deve conter apenas letras minúsculas, números e underscore" }, uniqueness: { scope: :flow_version_id }
  validates :name, presence: true, length: { maximum: 150 }
  validates :position, presence: true, numericality: { only_integer: true, greaer_than_or_equal_to: 0 }
  validates :config_json, presence: true

  scope :ordered, -> { order(:position, :id) }
  scope :llm_prompts, -> { where(type: :llm_prompt) }
  scope :web_searches, -> { where(type: :web_search) }

  before_validation :normalize_key

  private

  def normalize_key
    self.key = key.to_s.strip.downcase.gsub(/\s+/, "_")
  end
end
