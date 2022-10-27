# IT Job Board

This repo contains one of my simple side projects - IT Job Board suited for tech industry.

It's an **REST API-only** application, made with **Ruby on Rails**, mainly for learning purposes and discovering Rails and RSpec.

If you know Rails, you can checkout my code (e.g. `app/controllers/api/v1/job/offers_controller.rb`) and I'd be glad if you will leave feedback (especially negative, probably there are tons of things to improve).

Technologies: `Ruby on Rails 7`, `RSpec 5`, `PostgreSQL 13`, `Docker`

## Setup

If you are using **Windows**, install **Docker Desktop**, install **Linux** (in my case Ubuntu) on **WSL2**, enable docker integration and git clone application inside it.

Copy `.env.example` and rename it to `.env`.

```bash
# setup enviroment
docker compose build

# setup database
docker compose run --rm rails rails db:setup

# run enviroment
docker compose up -d
```

I recommend downloading `Docker` and `Dev Containers` extensions to `Visual Studio Code`, then attaching to running container directly (e.g. otherwise Rubocop will not work).

**Note**: If you are on Windows without using WSL2 and rails app doesn't start, it may be due to Windows line endings. Try disabling git automatic conversion, clone the project and try again:
```
git config --global core.autocrlf input
```

## Overview
In the current state of project, I've implemented basic functionalities listed below:
- 🏢 Employers can provide a lot of details and **highly customize job offer**.
- 🔎 **Filtering, sorting, paginating and searching** through all job offers.
- 💻 Custom panels for **Candidates** and **Employers**.
- 📨 **Anyone can apply** for job offer.
- 📊 Employers can **easily manage** candidates through recruitment process.

RSpec:
- ✔️ Models
- ❌ Requests
- ❌ Serializers

TODO:
- ❌ Add tests to all models, controllers and serializers.
- ❌ Add subscription based model for employers and pricing plans.

### Example API responses:

Below there are example responses from endpoints.

`/job/offers/:uuid` - full single job offer:
```json
{
  "id": "0dd337b5-9521-4916-888e-35ca85c5dfd0",
  "title": "Senior Ruby Developer",
  "body": "offer body",
  "seniority": 4,
  "valid_until": "2023-09-29T08:12:57.262Z",
  "rodo": null,
  "remote": 5,
  "interview_online": true,
  "data": {},
  "is_active": true,
  "slug": "senior-ruby-developer",
  "travelling": "none",
  "ua_supported": false,
  "external_link": null,
  "category": {
    "name": "backend"
  },
  "technology": {
    "name": "ruby"
  },
  "company": {
    "name": "Example company",
    "logo": "https://job-board-rails.com/attachments/8vjkfg7345hjfg89xqe",
    "size": 100,
    "data": {
      "links": [
        {
          "name": "site",
          "url": "https:/example-company.com"
        },
        {
          "name": "linkedin",
          "url": "https://www.linkedin.com/company/example-company/"
        }
      ]
    }
  },
  "skills": [
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
    },
    {
      "name": "AWS",
      "level": 2,
      "optional": true
    }
  ],
  "benefits": [
    {
      "group": "health",
      "name": "private health care"
    },
    {
      "group": "office",
      "name": "free food in the office"
    },
    {
      "group": "office",
      "name": "private parking spot"
    },
    {
      "group": "office",
      "name": "standing desk"
    }
  ],
  "contracts": [
    {
      "employment": "b2b",
      "from": "8756.0",
      "to": "15343.0",
      "currency": "pln",
      "paid_vacation": true,
      "payment_period": "monthly"
    },
    {
      "employment": "uop",
      "from": "5923.0",
      "to": "11869.0",
      "currency": "pln",
      "paid_vacation": true,
      "payment_period": "monthly"
    }
  ],
  "locations": [
    {
      "street": "ul. Kolejowa",
      "building_number": "2",
      "zip_code": "35-123",
      "city": "Rzeszów",
      "country": "Poland"
    },
    {
      "street": "ul. Słoneczna",
      "building_number": "678",
      "zip_code": "65-788",
      "city": "Warszawa",
      "country": "Poland"
    },
    {
      "street": "ul. Drewniana",
      "building_number": "43/5",
      "zip_code": "12-163",
      "city": "Kraków",
      "country": "Poland"
    }
  ],
  "languages": [
    {
      "name": "English",
      "code": "en"
    },
    {
      "name": "Polish",
      "code": "pl"
    }
  ],
  "equipment": {
    "computer": "notebook",
    "monitor": 2,
    "linux": false,
    "mac_os": true,
    "windows": false
  }
}

```

`/employer/job/applications/:uuid` - single job application with statuses history:
```json
{
  "id": "da1bc7aa-b203-4357-a9a5-2be60bd355e2",
  "name": "Jan Kowalski",
  "email": "jan.kowalski@gmail.com",
  "phone": "975864753",
  "cv": "https://job-board-rails.com/attachments/834d7234d234789423d",
  "note": "",
  "city": "Rzeszow",
  "work_form": "remote",
  "contract": "uop",
  "start_time": "now",
  "working_hours": "full",
  "closed_at": null,
  "starred": false,
  "data": {},
  "statuses": [
    {
      "status": "new",
      "note": "...",
      "created_at": "2022-10-12T12:10:21.634Z"
    },
    {
      "status": "in_progress",
      "note": "...",
      "created_at": "2022-10-13T14:30:10.321Z"
    },
    {
      "status": "hired",
      "note": "...",
      "created_at": "2022-10-18T18:23:34.153Z"
    }
  ]
}
```