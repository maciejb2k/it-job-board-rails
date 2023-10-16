require 'database_cleaner'

DatabaseCleaner.clean_with(:truncation)

CATEGORIES = %w[backend frontend fullstack mobile testing devops embedded
                security gaming ai big_data it_administrator agile
                product_management project_manager business_intelligence
                business analysis design sales marketing backoffice hr others]

TECHNOLOGIES = ['js', '.net', 'sql', 'java', 'python', 'react', 'aws', 'ts', 'html', 'angular',
                'azure', 'php', 'c++', 'android', 'kotlin', 'vuejs', 'ios', 'golang', 'spark',
                'scala', 'c', 'hadoop', 'ruby on rails', 'ruby', 'flutter', 'elixir', 'c#',
                'react native']

SKILLS = ['Ruby', 'Ruby on Rails', 'RSpec', 'PostgreSQL', 'Git', 'Docker', 'AWS', 'Azure',
          'React', 'Angular', 'Vue.js', 'JavaScript', 'TypeScript', 'HTML', 'CSS', 'SASS',
          'LESS', 'Java', 'Python', 'C++', 'C#', 'C', 'PHP', 'Android', 'iOS', 'Kotlin',
          'Swift', 'Golang', 'Scala', 'Spark', 'Hadoop', 'Elixir', 'Flutter', 'React Native',
          'SQL', 'NoSQL', 'MongoDB', 'Redis', 'Elasticsearch', 'Kafka', 'RabbitMQ',
          'Kubernetes', 'Docker', 'Linux', 'Windows', 'AWS', 'Azure', 'GCP', 'Heroku',
          'DigitalOcean', 'Git', 'Jira', 'Confluence', 'Bitbucket', 'Github', 'Gitlab',
          'Agile', 'Scrum', 'Kanban', 'TDD', 'BDD', 'DDD', 'SOLID', 'OOP', 'Design Patterns',
          'Microservices', 'REST', 'GraphQL', 'CI/CD', 'DevOps', 'Big Data',
          'Machine Learning', 'Deep Learning', 'Computer Vision', 'NLP', 'Data Science',
          'Business Intelligence', 'Business Analysis', 'Product Management',
          'Project Management', 'Sales', 'Marketing', 'Backoffice', 'HR']

SENIORITY_LEVELS = %w[Intern Junior Mid Senior]

JOB_ROLES = %w[Developer Engineer Programmer]

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

250.times do |i|
  seniority_level = Faker::Number.between(from: 1, to: 4)
  technology = Technology.find_by(name: TECHNOLOGIES.sample)
  job_title =
    "#{SENIORITY_LEVELS[seniority_level - 1]} #{technology.name} #{JOB_ROLES.sample}".titleize

  job_skills = []
  rand(3..12).times do
    job_skills << {
      "name": SKILLS.sample,
      "level": Faker::Number.between(from: 1, to: 5),
      "optional": [true, false].sample
    }
  end

  job_locations = []
  rand(1..5).times do
    job_locations << {
      "city": Faker::Address.city,
      "street": Faker::Address.street_name,
      "building_number": Faker::Address.building_number,
      "zip_code": Faker::Address.zip_code,
      "country": "Poland",
      "country_code": "PL"
    }
  end

  job_contacts = []
  rand(1..3).times do
    job_contacts << {
      "first_name": Faker::Name.first_name,
      "last_name": Faker::Name.last_name,
      "email": Faker::Internet.email,
      "phone": Faker::PhoneNumber.cell_phone
    }
  end

  params = {
    "offer": {
      "title": job_title,
      "seniority": seniority_level,
      "body": Faker::Lorem.paragraph(sentence_count: 20),
      "valid_until": [1, 2, 3].sample.year.from_now,
      "is_active": [true, false].sample,
      "remote": Faker::Number.between(from: 0, to: 5),
      "interview_online": [true, false].sample,
      "category_id": Category.find_by(name: CATEGORIES.sample).id,
      "technology_id": technology.id,
      "employer_id": Employer.find_by(email: "employer#{rand(1..3)}@company.com").id,
      "data": '{"links": []}',
      "job_skills_attributes": job_skills,
      "job_benefits_attributes": [],
      "job_contracts_attributes": [
        {
          "employment": 'b2b',
          "from": rand(3000..9000),
          "to": rand(10000..30_000),
          "currency": 'pln',
          "hide_salary": [true, false].sample,
          "payment_period": 'monthly'
        },
        {
          "employment": 'uop',
          "from": rand(4000..11000),
          "to": rand(12000..25_000),
          "currency": 'pln',
          "hide_salary": [true, false].sample,
          "payment_period": 'monthly'
        }
      ],
      "job_locations_attributes": job_locations,
      "job_company_attributes": {
        "name": Faker::Company.name,
        "logo": Faker::Company.logo,
        "size": 100,
        "data": '{"links": []}'
      },
      "job_contacts_attributes": job_contacts,
      "job_languages_attributes": [
        {
          "name": 'English',
          "code": 'en',
          "proficiency": ['a2', 'b1', 'b2', 'c1', 'c2'].sample,
        },
        {
          "name": 'Polish',
          "code": 'pl'
        }
      ],
      "job_equipment_attributes": {
        "computer": ["notebook", "desktop", "macbook"].sample,
        "monitor": Faker::Number.between(from: 1, to: 3)
      }
    }
  }

  Job::Offer.create!(params[:offer])
  p "Created ##{i} job offers"
end

p "Created #{Job::Offer.count} job offers"
