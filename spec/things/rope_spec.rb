require 'spec_helper'

describe Things::Rope do
  subject(:rope) { described_class.new(params) }

  let(:params) { { description: 'Description' } }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:name=) }

  it { is_expected.to respond_to(:description) }
  it { is_expected.to respond_to(:description=) }

  describe 'attributes' do
    it 'sets name' do
      expect(rope.name).to eq('Rope')
    end
  end

  describe '#climbable?' do
    it 'returns true' do
      expect(rope.climbable?).to eq(true)
    end
  end
end
