class Task < ApplicationRecord
  belongs_to :section
  has_many :actions, dependent: :destroy
  has_many :notes, dependent: :destroy

  default_scope { order(order: "asc") }

  delegate :project, to: :section

  def actions_count
    @actions_count ||= actions.where(action_type: "single-checkbox").count
  end

  def completed_actions_count
    @completed_actions_count ||= actions.where(action_type: "single-checkbox").where(completed: true).count
  end

  def status
    return :not_applicable if not_applicable? && optional?

    if completed_actions_count == 0
      :not_started
    elsif completed_actions_count == actions_count
      :completed
    elsif completed_actions_count < actions_count
      :in_progress
    end
  end
end
