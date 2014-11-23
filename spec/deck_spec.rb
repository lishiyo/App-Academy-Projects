require 'rspec'
require 'deck'

describe Deck do
	describe "::create_deck" do
		subject(:create_deck) { Deck.create_deck }

    it "starts with a count of 52" do
			expect(create_deck.count).to eq(52)
    end

    it "returns all cards without duplicates" do
			deduped_cards = create_deck
      .map { |card| [card.suit, card.value] }
      .uniq
      .count
      expect(deduped_cards).to eq(52)
    end
  end

  let(:cards) do
    cards = [
			Card.new(:king, :spades),
			Card.new(:queen, :spades),
      Card.new(:jack, :spades)
    ]
  end

  describe "#initialize" do
    it "by default fills itself with 52 cards" do
      deck = Deck.new
			expect(deck.count).to eq(52)
    end

    it "can be initialized with an array of cards" do
      deck = Deck.new(cards)
			expect(deck.count).to eq(3)
    end
  end

  let(:deck) do
    Deck.new(cards.dup)
  end

  it "does not expose its cards directly" do
    expect(deck).not_to respond_to(:cards)
  end

	describe "#take" do
		
    # **uses the front of the cards array as the top**
    it "takes cards off the top of the deck" do
			expect(deck.take(1)).to eq(cards[0..0])
			expect(deck.take(2)).to eq(cards[1..2])
    end

    it "removes cards from deck on draw" do
			deck.take(2)
      expect(deck.count).to eq(1)
    end

    it "doesn't allow you to draw more cards than are in the deck" do
      expect do
				deck.take(4)
      end.to raise_error("not enough cards")
    end
  end

end
