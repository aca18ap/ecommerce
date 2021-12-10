require 'rails_helper'

describe 'Newsletters' do

  context 'If I provide a valid email address' do
    specify 'I can register my interest as a business' do
      skip 'IMPLEMENT TEST'
    end

    specify 'I can register my interest as a free customer' do
      skip 'IMPLEMENT TEST'
    end

    specify 'I can register my interest as a solo customer' do
      skip 'IMPLEMENT TEST'
    end

    specify 'I can register my interest as a family customer' do
      skip 'IMPLEMENT TEST'
    end
  end

  context 'If I provide an invalid email address' do
    specify 'I am shown an error' do
      skip 'IMPLEMENT TEST'
    end
  end

  context 'If I have already registered interest' do
    specify 'I am shown an error' do
      skip 'IMPLEMENT TEST'
    end
  end

  context 'Security' do
    specify 'I cannot perform an XSS attack' do
      skip 'IMPLEMENT TEST'
    end

    specify 'I cannot perform an SQL injection attack' do
      skip 'IMPLEMENT TEST'
    end
  end
end
