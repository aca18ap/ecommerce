class Product < ApplicationRecord
  validates :name, :type, :url, :manufacturer, :manufacturer_country,  presence: true
  validates :url, uniqueness: true

  

end
