require 'rspec'
require 'card'

describe Card do

  subject(:card) { Card.new(:ace, :diamonds) }

  describe '#initialize' do

    it 'is created with value and suit' do
      expect(card.value).to eq(:ace)
      expect(card.suit).to eq(:diamonds)
    end
  end

  describe '#==(other_card)' do

    it 'should be true for other card of same val & suit' do
      card2 = Card.new(:ace, :diamonds)
      expect(card).to eq(card2)
    end

    it 'should be false for other card of diff val & suit' do
      card2 = Card.new(:ace, :clubs)
      expect(card).not_to eq(card2)
    end
  end

  describe '#render' do
    it 'should return the proper string represention of card' do
      expect(card.render).to eq("A♦")
    end
  end
end
