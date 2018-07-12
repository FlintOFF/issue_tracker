class Issue < ApplicationRecord
  # attr_writer :title, :body, :state #todo

  enum status: { pending: 0, in_progress: 5, resolved: 9 }

  belongs_to :client
  belongs_to :manager, optional: true

  # validations
  validates :title, presence: true
  validates :body, presence: true

  # scopes
  scope :by_status, ->(status) { where(status: status) }
end
