# frozen_string_literal: true

require 'rails_helper'

# Tak mi się wydaje, że testy serializerów nie są koniecznie.
#
# Bo to tylko sprawdza czy w pliku serializera istnieje atrybut i tyle.
# Nie ma to nic wspólnego z BDD i testowaniem zachowania aplikacji,
# tylko to jest bardziej takie testowanie jednostkowe na poziomie kodu.
#
# Nie będę pisać testów serializerów, ten będzie tylko służył jako przykład.

RSpec.describe 'Api::V1::Job::SimpleOfferSerializer' do
  let_it_be(:job_offer) { create(:job_offer) }
  let_it_be(:serialization) do
    ActiveModelSerializers::Adapter.create(
      Api::V1::Job::SimpleOfferSerializer.new(job_offer)
    )
  end

  subject(:serializer) { JSON.parse(serialization.to_json) }

  it "matches 'id' attribute" do
    expect(serializer['id']).to eql(job_offer.id)
  end

  it "matches 'title' attribute" do
    expect(serializer['title']).to eql(job_offer.title)
  end

  it "matches 'slug' attribute" do
    expect(serializer['slug']).to eql(job_offer.slug)
  end

  it "matches 'seniority' attribute" do
    expect(serializer['seniority']).to eql(job_offer.seniority)
  end

  it "matches 'valid_until' attribute" do
    expect(Time.zone.parse(serializer['valid_until']).utc.to_s).to(
      eql(job_offer.valid_until.utc.to_s)
    )
  end

  it "matches 'is_active' attribute" do
    expect(serializer['is_active']).to eql(job_offer.is_active)
  end

  it "matches 'remote' attribute" do
    expect(serializer['remote']).to eql(job_offer.remote)
  end

  it "matches 'ua_supported' attribute" do
    expect(serializer['ua_supported']).to eql(job_offer.ua_supported)
  end

  it "matches 'interview_online' attribute" do
    expect(serializer['interview_online']).to eql(job_offer.interview_online)
  end

  it "matches 'travelling' attribute" do
    expect(serializer['travelling']).to eql(job_offer.travelling)
  end

  describe "'category' association" do
    it "matches 'id' attribute" do
      expect(serializer['category']['id']).to eql(job_offer.category.id)
    end

    it "matches 'name' attribute" do
      expect(serializer['category']['name']).to eql(job_offer.category.name)
    end
  end

  describe "'technology' association" do
    it "matches 'id' attribute" do
      expect(serializer['technology']['id']).to eql(job_offer.technology.id)
    end

    it "matches 'name' attribute" do
      expect(serializer['technology']['name']).to eql(job_offer.technology.name)
    end
  end

  # Wybieranie indeksu tablicy na sztywno wydaje mi się mega gównem i mega risky.
  # Tutaj musze wymyslić coś lepszego.
  describe "'skills' association" do
    it "matches 'id' attribute" do
      expect(serializer['skills'][0]['id']).to eql(job_offer.job_skills[0].id)
    end

    it "matches 'name' attribute" do
      expect(serializer['skills'][0]['name']).to eql(job_offer.job_skills[0].name)
    end

    it "matches 'level' attribute" do
      expect(serializer['skills'][0]['level']).to eql(job_offer.job_skills[0].level)
    end
  end
end
