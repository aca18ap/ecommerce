# frozen_string_literal: true

require 'rails_helper'

describe 'Signing up as a staff member' do
  specify 'I should not be able to sign_up' do
    visit new_staff_registration_path

    expect(page).to have_current_path new_staff_session_path
  end
end
