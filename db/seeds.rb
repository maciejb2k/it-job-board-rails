# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'database_cleaner'

DatabaseCleaner.clean_with(:truncation)

CATEGORIES = %w[backend frontend fullstack mobile testing devops embedded 
                security gaming ai big_data it_administrator agile 
                product_management project_manager business_intelligence 
                business analysis design sales marketing backoffice hr others]

TECHNOLOGIES = %w[js .net sql java python react aws ts html angular azure php 
                  c++ android kotlin vuejs ios golang spark scala c hadoop 
                  ruby\ on\ rails ruby flutter elixir c# react\ native]

CATEGORIES.each do |name| 
  Category.create!(name:)
end

p "Created #{Category.count} categories"

TECHNOLOGIES.each do |name| 
  Technology.create!(name:)
end

p "Created #{Technology.count} technologies"

Employer.create(email: 'employer1@company.com', password: 'password')
Employer.create(email: 'employer2@company.com', password: 'password')
Employer.create(email: 'employer3@company.com', password: 'password')

25.times do |i|
  params = {
    "offer": {
      "title": "Senior Ruby Developer",
      "seniority": Faker::Number.between(from: 1, to: 4),
      "body": "offer body",
      "valid_until": "2023-09-29T08:12:57.262Z",
      "is_active": [true, false].sample,
      "remote": Faker::Number.between(from: 0, to: 5),
      "interview_online": true,
      "category_id": Category.find_by(name: CATEGORIES.sample).id,
      "technology_id": Technology.find_by(name: TECHNOLOGIES.sample).id,
      "employer_id": Employer.find_by(email: "employer#{rand(1..3)}@company.com").id,
      "data": "{\"links\": []}",
      "job_skills_attributes": [  
          {
            "name": "Ruby",
            "level": 5
          },
          {
            "name": "Ruby on Rails",
            "level": 4
          },
          {
            "name": "RSpec",
            "level": 4
          },
          {
            "name": "PostgreSQL",
            "level": 3
          },
          {
            "name": "Git",
            "level": 3
          },
          {
            "name": "Docker",
            "level": 2,
            "optional": true
          }
      ],
      "job_benefits_attributes": [],
      "job_contracts_attributes": [
        {
          "employment": "b2b",
          "from": rand(3000..5000),
          "to": rand(7000..10000),
          "currency": "pln",
          "hide_salary": [true, false].sample,
          "payment_period": "monthly"
        },
        {
          "employment": "uop",
          "from": rand(4000..6000),
          "to": rand(8000..14000),
          "currency": "pln",
          "hide_salary": [true, false].sample,
          "payment_period": "monthly"
        }
      ],
      "job_locations_attributes": [
          {
            "city": "Rzeszów",
            "street": "ul. Kolejowa",
            "building_number": "2",
            "zip_code": "35-123",
            "country": "Poland",
            "country_code": "PL"
          },
          {
            "city": "Warszawa",
            "street": "ul. Słoneczna",
            "building_number": "678",
            "zip_code": "65-788",
            "country": "Poland",
            "country_code": "PL"
          },
          {
            "city": "Kraków",
            "street": "ul. Drewniana",
            "building_number": "43/5",
            "zip_code": "12-163",
            "country": "Poland",
            "country_code": "PL"
        }
      ],
      "job_company_attributes": {
          "name": "W Gorącej Wodzie Company",
          "logo": "https://ecs-aws.com/path/to/file.png",
          "size": 100,
          "data": "{\"links\": []}"
      },
      "job_contacts_attributes": [
        {
          "first_name": "Agnieszka",
          "last_name": "TuNieMieszka",
          "email": "masnyben@gmail.com",
          "phone": "123456789"
        },
        {
          "first_name": "Tomasz",
          "last_name": "Kowalski",
          "email": "topewniejerzy@gmail.com"
        }
      ],
      "job_languages_attributes": [
          {
              "name": "English",
              "code": "en",
              "proficiency": "b2"
          },
          {
            "name": "Polish",
            "code": "pl"
        }
      ],
      "job_equipment_attributes": {
        "computer": "notebook",
        "monitor": 1
      }
    }
  }

  Job::Offer.create!(params[:offer])
  p "Created ##{i} job offers"
end

p "Created #{Job::Offer.count} job offers"
