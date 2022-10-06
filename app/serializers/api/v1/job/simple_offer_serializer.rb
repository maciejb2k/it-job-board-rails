# frozen_string_literal: true

class Api::V1::Job::SimpleOfferSerializer < ActiveModel::Serializer
  attributes :id,
             :title,
             :slug,
             :seniority,
             :valid_until,
             :is_active,
             :remote,
             :ua_supported,
             :travelling

  belongs_to :category
  belongs_to :technology

  has_many :job_skills, key: :skills do
    object.job_skills.where(optional: false)
  end
  has_many :job_contracts, key: :contracts
  has_many :job_languages, key: :languages
  has_many :job_locations, key: :locations

  # Category
  class CategorySerializer < ActiveModel::Serializer
    attributes :id, :name
  end

  # Technology
  class TechnologySerializer < ActiveModel::Serializer
    attributes :id, :name
  end

  # Skills
  class Job::SkillSerializer < ActiveModel::Serializer
    attributes :name, :level
  end

  # Contracts
  class Job::ContractSerializer < ActiveModel::Serializer
    attributes :employment, :from, :to, :currency

    def from
      object.hide_salary ? 'hidden' : object.from
    end

    def to
      object.hide_salary ? 'hidden' : object.to
    end
  end

  # Languages
  class Job::LanguageSerializer < ActiveModel::Serializer
    attributes :name, :code
  end

  # Locations
  class Job::LocationSerializer < ActiveModel::Serializer
    attributes :city
  end
end