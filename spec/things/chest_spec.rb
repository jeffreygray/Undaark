require 'spec_helper'

describe Things::Chest do
  subject(:chest) { described_class.new(params) }

  let(:params) { { description: 'Description', loot: 10 } }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:name=) }

  it { is_expected.to respond_to(:description) }
  it { is_expected.to respond_to(:description=) }

  it { is_expected.to respond_to(:loot) }
  it { is_expected.to respond_to(:loot=) }

  it { is_expected.to respond_to(:closed) }
  it { is_expected.to respond_to(:closed=) }

  describe 'attributes' do
    it 'sets name' do
      expect(chest.name).to eq('Chest')
    end

    it 'sets loot to zero' do
      expect(chest.loot).to eq(10)
    end

    it 'sets closed to true' do
      expect(chest.closed).to eq(true)
    end
  end

  describe '#openable?' do
    it 'returns true' do
      expect(chest.openable?).to eq(true)
    end
  end

  describe '#open' do
    let(:player) { Things::Player.new({}) }

    it 'sets loot to zero' do
      chest.open(player)

      expect(chest.loot).to eq(0)
    end

    it 'sets closed to false' do
      chest.open(player)

      expect(chest.closed).to eq(false)
    end

    it 'increments player cash' do
      expect { chest.open(player) }.to change(player, :cash).from(0).to(10)
    end
  end
end
