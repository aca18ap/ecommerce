# frozen_string_literal: true

require 'rails_helper'

describe 'Product Report Page' do
  context 'Given there are 10,000 Product Reports in the system' do
    before do
      current_time = Time.zone.now
      product = FactoryBot.create(:product)
      customer = FactoryBot.create(:customer)
      ProductReport.insert_all(
        10_000.times.map do |i|
          {
            content: "MyReport #{i}",
            product_id: product.id,
            customer_id: customer.id,
            created_at: current_time,
            updated_at: current_time
          }
        end
      )
    end

    context 'As an admin' do
      specify 'I can see the list of Product Reports within 0.5 second of visiting the page' do
        login_as(FactoryBot.create(:admin), scope: :staff)
        expect do
          visit product_reports_path
        end.to perform_under(0.5).sec
      end
    end
  end
end
