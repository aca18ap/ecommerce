# frozen_string_literal: true

require 'rails_helper'

describe 'Review Page' do
  context 'Given there are 10,000 Reviews in the system' do
    before do
      current_time = Time.zone.now

      Review.insert_all(
        10_000.times.map do |i|
          {
            description: "MyDescription #{i}",
            rating: rand(1..4),
            rank: i,
            hidden: false,     
            created_at: current_time,
            updated_at: current_time
          }
        end
      )
    end

    context 'As a visitor' do
      specify 'I can see the list of Reviews within 0.5 second of visiting the page' do
        expect { visit reviews_path }.to perform_under(0.5).sec
      end
    end
  end
end