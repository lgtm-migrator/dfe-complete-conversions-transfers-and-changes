class User < ApplicationRecord
  has_many :projects, foreign_key: "caseworker"
  has_many :notes

  scope :order_by_first_name, -> { order(first_name: :asc) }
  scope :team_leaders, -> { where(team_leader: true).order_by_first_name }
  scope :regional_delivery_officers, -> { where(regional_delivery_officer: true).order_by_first_name }
  scope :caseworkers, -> { where(caseworker: true).order_by_first_name }

  def full_name
    "#{first_name} #{last_name}" if first_name.present? && last_name.present?
  end
end
