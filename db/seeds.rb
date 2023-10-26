require 'database_cleaner'

DatabaseCleaner.clean_with(:truncation)

CATEGORIES = [
  { name: 'backend', label: 'Backend' },
  { name: 'frontend', label: 'Frontend' },
  { name: 'fullstack', label: 'Fullstack' },
  { name: 'mobile', label: 'Mobile' },
  { name: 'testing', label: 'Testing' },
  { name: 'devops', label: 'DevOps' },
  { name: 'embedded', label: 'Embedded' },
  { name: 'security', label: 'Security' },
  { name: 'gaming', label: 'Gaming' },
  { name: 'ai', label: 'AI' },
  { name: 'big_data', label: 'Big Data' },
  { name: 'it_administrator', label: 'IT Administrator' },
  { name: 'agile', label: 'Agile' },
  { name: 'product_management', label: 'Product Management' },
  { name: 'project_manager', label: 'Project Manager' },
  { name: 'business_intelligence', label: 'Business Intelligence' },
  { name: 'business_analysis', label: 'Business Analysis' },
  { name: 'design', label: 'Design' },
  { name: 'sales', label: 'Sales' },
  { name: 'marketing', label: 'Marketing' },
  { name: 'backoffice', label: 'Backoffice' },
  { name: 'hr', label: 'HR' },
  { name: 'others', label: 'Others' }
]

TECHNOLOGIES = [
  { name: 'js', label: 'JavaScript' },
  { name: '.net', label: '.NET' },
  { name: 'sql', label: 'SQL' },
  { name: 'java', label: 'Java' },
  { name: 'python', label: 'Python' },
  { name: 'react', label: 'React' },
  { name: 'aws', label: 'AWS' },
  { name: 'ts', label: 'TypeScript' },
  { name: 'html', label: 'HTML' },
  { name: 'angular', label: 'Angular' },
  { name: 'azure', label: 'Azure' },
  { name: 'php', label: 'PHP' },
  { name: 'c++', label: 'C++' },
  { name: 'android', label: 'Android' },
  { name: 'kotlin', label: 'Kotlin' },
  { name: 'vuejs', label: 'Vue.js' },
  { name: 'ios', label: 'iOS' },
  { name: 'golang', label: 'Golang' },
  { name: 'spark', label: 'Spark' },
  { name: 'scala', label: 'Scala' },
  { name: 'c', label: 'C' },
  { name: 'ruby on rails', label: 'Ruby on Rails' },
  { name: 'ruby', label: 'Ruby' },
  { name: 'flutter', label: 'Flutter' },
  { name: 'elixir', label: 'Elixir' },
  { name: 'c#', label: 'C#' },
  { name: 'react native', label: 'React Native' }
]

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

CATEGORIES.each do |category|
  Category.create!(category)
end

p "Created #{Category.count} categories"

TECHNOLOGIES.each do |technology|
  Technology.create!(technology)
end

p "Created #{Technology.count} technologies"

Employer.create(email: 'employer1@company.com', password: 'password')
Employer.create(email: 'employer2@company.com', password: 'password')
Employer.create(email: 'employer3@company.com', password: 'password')

250.times do |i|
  seniority_level = Faker::Number.between(from: 1, to: 4)
  technology = Technology.find_by(name: TECHNOLOGIES.sample[:name])
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
      "category_id": Category.find_by(name: CATEGORIES.sample[:name]).id,
      "technology_id": technology.id,
      "ua_supported": [true, false].sample,
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
