# frozen_string_literal: true

module Job
  class Language < ApplicationRecord
    validates :name, presence: true
    validates :code, presence: true

    belongs_to :job_offer, class_name: 'Job::Offer'
  end
end
