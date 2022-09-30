# frozen_string_literal: true

module Job
  class OfferSerializer < ActiveModel::Serializer
    attributes :id,
               :title,
               :seniority,
               :body,
               :valid_until,
               :is_active,
               :remote,
               :rodo,
               :interview_online,
               :category,
               :technology,
               :user

    attribute :job_skills, key: :skills
    attribute :job_benefits, key: :benefits
    attribute :job_contracts, key: :contracts
    attribute :job_locations, key: :locations
    attribute :job_companies, key: :company
    attribute :job_contacts, key: :contacts
    attribute :job_languages, key: :languages

    def rodo
      object.rodo || ''
    end
  end
end
