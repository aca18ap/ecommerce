# frozen_string_literal: true

require 'rails_helper'

describe 'FAQ Page' do
  context 'Given there are 10,000 FAQs in the system' do
    before do
      current_time = Time.zone.now

      Faq.insert_all(
        10_000.times.map do |i|
          {
            question: "MyQuestion #{i}",
            answer: "MyAnswer #{i}",
            clicks:  rand(1..99),
            hidden: false,
            usefulness: 0,
            created_at: current_time,
            updated_at: current_time
          }
        end
      )
    end

    context 'As a visitor' do
      specify 'I can see the list of FAQs within 0.5 second of visiting the page' do
        expect { visit '/faqs' }.to perform_under(0.5).sec
      end
    end
  end
end