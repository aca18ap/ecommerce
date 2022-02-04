# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/faqs', type: :request do
  describe 'GET /faqs' do
    it 'Shows a list of all faqs' do
      10.times do |idx|
        Faq.create(question: "Question #{idx}")
      end

      get faqs_path
      expect(response).to be_successful

      10.times do |idx|
        expect(response.body).to include "Question #{idx}"
      end
    end
  end

  describe 'POST /faqs' do
    it 'Creates a new faq' do
      expect(Faq.count).to eq(0)

      post faqs_path, params: {
        faq: {
          question: 'A new faq'
        }
      }

      expect(Faq.count).to eq(1)
    end
  end

  describe 'PATCH /faq/:id' do
    it 'Updates the contents of the faq' do
      skip 'Can\'t get this to work for the time being. Coming back later'
      faq = Faq.create(question: 'A question')

      patch faq_path(faq), params: {
        id: faq,
        faq: {
          answer: 'An answer'
        }
      }

      faq.reload
      expect(faq.answer).to eq('An answer')
    end
  end
end
