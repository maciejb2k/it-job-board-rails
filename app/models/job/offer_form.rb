# frozen_string_literal: true

module Job
  class OfferForm
    include ActiveModel::Model
    include ActiveModel::Serialization

    attr_accessor :offers_attributes,
                  :skills_attributes,
                  :benefits_attributes,
                  :contracts_attributes,
                  :locations_attributes,
                  :company_attributes,
                  :contacts_attributes,
                  :languages_attributes

    attr_reader :offer

    validates :skills_attributes,
              :offers_attributes,
              :contracts_attributes,
              :locations_attributes,
              :company_attributes,
              :languages_attributes,
              presence: true
    validates :benefits_attributes,
              :contacts_attributes,
              :contracts_attributes,
              :locations_attributes,
              :languages_attributes,
              is_array: true
    validates :offers_attributes,
              :company_attributes,
              is_hash: true

    def save
      return false unless valid?

      ActiveRecord::Base.transaction do
        create_offer
        create_skills
        create_benefits
        create_contracts
        create_locations
        create_company
        create_contacts
        create_languages

        true
      end
    rescue ActiveRecord::RecordInvalid
      false
    end

    private

    def create_offer
      @offer = Job::Offer.create(offers_attributes)
      add_errors(@offer) if @offer.invalid?
      @offer.save!
    end

    def create_skills
      @skills = @offer.job_skills.create(skills_attributes)
      @skills.each do |skill|
        add_errors(skill) if skill.invalid?
        skill.save!
      end
    end

    def create_benefits
      @benefits = @offer.job_benefits.create(benefits_attributes)
      @benefits.each do |benefit|
        add_errors(benefit) if benefit.invalid?
        benefit.save!
      end
    end

    def create_contracts
      @contracts = @offer.job_contracts.create(contracts_attributes)
      @contracts.each do |contract|
        add_errors(contract) if contract.invalid?
        contract.save!
      end
    end

    def create_locations
      @locations = @offer.job_locations.create(locations_attributes)
      @locations.each do |location|
        add_errors(location) if location.invalid?
        location.save!
      end
    end

    def create_company
      @company = @offer.job_companies.create(company_attributes)
      add_errors(@company) if @company.invalid?
      @company.save!
    end

    def create_contacts
      @contacts = @offer.job_contacts.create(contacts_attributes)
      @contacts.each do |contact|
        add_errors(contact) if contact.invalid?
        contact.save!
      end
    end

    def create_languages
      @languages = @offer.job_languages.create(languages_attributes)
      @languages.each do |language|
        add_errors(language) if language.invalid?
        language.save!
      end
    end

    def add_errors(obj)
      obj.errors.messages.each do |attribute, message|
        errors.add("#{obj.class.table_name}.#{attribute}", message)
      end
    end
  end
end
