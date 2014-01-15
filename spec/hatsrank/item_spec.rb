require 'spec_helper'

describe Hatsrank::Item do
  let(:item) { Hatsrank::Item.new }
  let(:descriptions) { [] }
  before do
    item.descriptions = descriptions
  end

  describe '#effects' do
    subject { item.effects }
    context 'no descriptions' do
      specify { should == [] }
    end
    context 'has descriptions' do
      let(:descriptions) { [Hatsrank::Description.new] }
      before do
        descriptions.first.value = description_text
      end
      context 'no effects' do
        let(:description_text) { 'lols no effect' }
        specify { should == [] }
      end
      context 'has an effect' do
        let(:description_text) { 'Effect: FLAMING FIRE FLAMES' }
        specify { should == descriptions }
      end
    end
  end
end
