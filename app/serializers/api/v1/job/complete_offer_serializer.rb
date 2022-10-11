# frozen_string_literal: true

class Api::V1::Job::CompleteOfferSerializer < ActiveModel::Serializer
  attributes :id,
             :title,
             :body,
             :seniority,
             :valid_until,
             :rodo,
             :remote,
             :interview_online,
             :data,
             :is_active,
             :slug,
             :travelling,
             :ua_supported,
             :external_link,
             :category,
             :technology,
             :company,
             :skills,
             :benefits,
             :contracts,
             :locations,
             :languages,
             :equipment

  def category
    CategorySerializer.new(object.category).attributes
  end

  def technology
    TechnologySerializer.new(object.technology).attributes
  end

  def skills
    object.job_skills.map do |item|
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

  def benefits
    object.job_benefits.map do |item|
      Job::BenefitSerializer.new(item).attributes
    end
  end

  def company
    Job::CompanySerializer.new(object.job_companies).attributes
  end

  def equipment
    Job::EquipmentSerializer.new(object.job_equipment).attributes
  end

  # Category
  class CategorySerializer < ActiveModel::Serializer
    attributes :name
  end

  # Technology
  class TechnologySerializer < ActiveModel::Serializer
    attributes :name
  end

  # Skills
  class Job::SkillSerializer < ActiveModel::Serializer
    attributes :name, :level
  end

  # Contracts
  class Job::ContractSerializer < ActiveModel::Serializer
    attributes :employment, :from, :to, :currency, :paid_vacation, :payment_period

    def from
      object.hide_salary ? 'undisclosed' : object.from
    end

    def to
      object.hide_salary ? 'undisclosed' : object.to
    end
  end

  # Languages
  class Job::LanguageSerializer < ActiveModel::Serializer
    attributes :name, :code
  end

  # Locations
  class Job::LocationSerializer < ActiveModel::Serializer
    attributes :street, :building_number, :zip_code, :city, :country
  end

  # Benefits
  class Job::BenefitSerializer < ActiveModel::Serializer
    attributes :group, :name
  end

  # Company
  class Job::CompanySerializer < ActiveModel::Serializer
    attributes :name, :logo, :size, :data
  end

  # Equipment
  class Job::EquipmentSerializer < ActiveModel::Serializer
    attributes :computer, :monitor, :linux, :mac_os, :windows
  end
end
