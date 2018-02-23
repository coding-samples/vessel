class Issue < ApplicationRecord

  enum status: { pending: 0, in_progress: 10, resolved: 20 }

  validates_presence_of :author_id
  validates_presence_of :manager_id, unless: :pending?

  belongs_to :author, class_name: 'User'
  belongs_to :manager, class_name: 'User', optional: true

  def assigned?
    manager_id.present?
  end

end
