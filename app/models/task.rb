class Task < ApplicationRecord
  belongs_to :section
  has_many :actions
end
