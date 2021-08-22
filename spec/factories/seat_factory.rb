# frozen_string_literal: true

FactoryBot.define do
  factory :seat do
    association :venue
    row       { 1 }
    column    { 1 }
    available { false }
  end
end
