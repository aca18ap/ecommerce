# frozen_string_literal: true

require 'rails_helper'

describe 'Layout accessibility' do
  feature 'Home', js: true do
    scenario 'is accessible' do
      visit root_path
      expect(page).to be_axe_clean
    end
  end
end
