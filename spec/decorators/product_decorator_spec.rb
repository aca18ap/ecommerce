require 'rails_helper'

RSpec.describe ProductDecorator do
    let(:material) { FactoryBot.create(:material)}
    let(:product) { FactoryBot.create(:product)}
    describe 'Product\'s materials' do
        context "When a view a list of products" do
            it "Shows the materials used" do
                skip 'Not sure how to test this yet'
                m = product.get_materials
                expect(m[0]).to eq('Timber')
            end
        end
    end

end
