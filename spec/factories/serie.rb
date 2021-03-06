# frozen_string_literal: true

FactoryBot.define do
  factory :serie do
    sequence(:original_title) { |n| "Film Production #{n}" }
    sequence(:title) { |n| "Production #{n}" }
    start_year 2016
    length 90
    synopsis "Synopsis"
    release DateTime.now
    brazilian_release DateTime.now
    age_range

    trait :invalid do
      original_title nil
      year nil
      length nil
    end
  end
end
