require 'spec_helper'

describe Things::Thing do
  subject(:thing) { described_class.new(params) }

  let(:params) { { name: 'Thing', description: 'Description' } }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:name=) }

  it { is_expected.to respond_to(:description) }
  it { is_expected.to respond_to(:description=) }

  describe '#fights?' do
    it 'returns false' do
      expect(thing.fights?).to eq(false)
    end
  end

  describe '#climbable?' do
    it 'returns false' do
      expect(thing.climbable?).to eq(false)
    end
  end

  describe '#openable?' do
    it 'returns false' do
      expect(thing.openable?).to eq(false)
    end
  end
end
