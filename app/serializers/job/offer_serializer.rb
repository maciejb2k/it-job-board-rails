# frozen_string_literal: true

module Job
  class OfferSerializer < ActiveModel::Serializer
    attributes :id,
               :title,
               :slug,
               :uuid,
               :seniority,
               :body,
               :valid_until,
               :is_active,
               :remote,
               :rodo,
               :interview_online,
               :ua_supported,
               :travelling,
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
    attribute :job_equipment, key: :equipment

    def rodo
      object.rodo || ''
    end
  end
end
