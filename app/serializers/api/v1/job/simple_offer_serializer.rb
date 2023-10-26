# frozen_string_literal: true

class Api::V1::Job::SimpleOfferSerializer < ActiveModel::Serializer
  attributes :id,
             :created_at,
             :title,
             :slug,
             :seniority,
             :valid_until,
             :is_active,
             :remote,
             :ua_supported,
             :interview_online,
             :travelling,
             :category,
             :technology,
             :skills,
             :contracts,
             :languages,
             :locations

  def category
    CategorySerializer.new(object.category).attributes
  end

  def technology
    TechnologySerializer.new(object.technology).attributes
  end

  def skills
    object.job_skills_required.map do |item|
      Job::SkillSerializer.new(item).attributes
    end
  end

  def contracts
    object.job_contracts.map do |item|
      Job::ContractSerializer.new(item).attributes
    end
  end

  def languages
    object.job_languages.map do |item|
      Job::LanguageSerializer.new(item).attributes
    end
  end

  def locations
    object.job_locations.map do |item|
      Job::LocationSerializer.new(item).attributes
    end
  end

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
    attributes :id, :name, :level
  end

  # Contracts
  class Job::ContractSerializer < ActiveModel::Serializer
    attributes :id, :employment, :from, :to, :currency

    def from
      object.hide_salary ? 'undisclosed' : object.from
    end

    def to
      object.hide_salary ? 'undisclosed' : object.to
    end
  end

  # Languages
  class Job::LanguageSerializer < ActiveModel::Serializer
    attributes :id, :name, :code
  end

  # Locations
  class Job::LocationSerializer < ActiveModel::Serializer
    attributes :id, :street, :building_number, :zip_code, :city, :country
  end
end
