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
      expect(Faq.count).to eq 0

      post faqs_path, params: {
        faq: {
          question: 'A new faq'
        }
      }

      expect(Faq.count).to eq 1
    end
  end

  describe 'PATCH /faq/:id' do
    context 'If authenticated as an admin' do
      before { login_as(FactoryBot.create(:admin)) }

      it 'Updates the contents of the faq' do
        faq = Faq.create(question: 'A question')

        patch faq_path(faq), params: {
          faq: {
            answer: 'An answer'
          }
        }

        faq.reload
        expect(faq.answer).to eq 'An answer'
      end
    end

    context 'If not authenticated as an admin' do
      it 'Does not update the contents of an faq' do
        faq = Faq.create(question: 'A question')

        patch faq_path(faq), params: {
          faq: {
            answer: 'An answer'
          }
        }

        faq.reload
        expect(faq.answer).to eq nil
      end
    end
  end

  describe 'PUT /faq/:id' do
    context 'If authenticated as an admin' do
      before { login_as(FactoryBot.create(:admin)) }

      it 'Updates the contents of the faq' do
        faq = Faq.create(question: 'A question')

        put faq_path(faq), params: {
          faq: {
            answer: 'An answer'
          }
        }

        faq.reload
        expect(faq.answer).to eq 'An answer'
      end
    end

    context 'If not authenticated as an admin' do
      it 'Does not update the contents of an faq' do
        faq = Faq.create(question: 'A question')

        put faq_path(faq), params: {
          faq: {
            answer: 'An answer'
          }
        }

        faq.reload
        expect(faq.answer).to eq nil
      end
    end
  end

  describe 'DELETE /faq/:id' do
    context 'If authenticated as an admin' do
      before { login_as(FactoryBot.create(:admin)) }

      it 'Updates removes the faq' do
        faq = Faq.create(question: 'A question')
        expect(Faq.count).to eq 1

        delete faq_path(faq)
        expect(Faq.count).to eq 0
      end
    end

    context 'If not authenticated as an admin' do
      it 'Does not remove the faq' do
        faq = Faq.create(question: 'A question')
        expect(Faq.count).to eq 1

        delete faq_path(faq)

        faq.reload
        expect(Faq.count).to eq 1
      end
    end
  end

  describe 'GET /faq/:id/answer' do
    context 'If authenticated as an admin' do
      before { login_as(FactoryBot.create(:admin)) }

      it 'Retrieves the page to answer an faq' do
        faq = Faq.create(question: 'A question', answer: 'An answer')

        get answer_faq_path(faq)
        expect(response).to be_successful
        expect(response.body).to include 'An answer'
      end
    end

    context 'If not authenticated as an admin' do
      it 'Does not retrieve the page to answer an faq' do
        faq = Faq.create(question: 'A question', answer: 'An answer')

        get answer_faq_path(faq)
        expect(response).to_not be_successful

        expect(response.body).to_not include 'An answer'
      end
    end
  end

  describe 'POST /faq/:id/like' do
    context 'If not authenticated as an admin' do
      it 'Does not retrieve the page to answer an faq' do
        faq = Faq.create(question: 'A question')

        post like_faq_path(faq)

        expect(response).to be_successful

      end
    end
  end
end
