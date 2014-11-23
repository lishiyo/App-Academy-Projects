require 'rspec'
require 'hand'

describe Hand do
  #subject(:hand) { Hand.new() }

  describe '#initialize' do
  end

  describe '#check_flush' do
    it "returns the high of a flush" do
      c1 = double("c1", value: 4, suit: :clubs)
      c2 = double("c2", value: 6, suit: :clubs)
      c3 = double("c3", value: 5, suit: :clubs)
      c4 = double("c4", value: 8, suit: :clubs)
      c5 = double("c5", value: 7, suit: :clubs)
      h = Hand.new([c1, c2, c3, c4, c5])
      expect(h.check_flush).to eq(8)
    end

    it "returns 0 for non-flush" do
      c1 = double("c1", value: 4, suit: :clubs)
      c2 = double("c2", value: 6, suit: :hearts)
      c3 = double("c3", value: 5, suit: :clubs)
      c4 = double("c4", value: 8, suit: :clubs)
      c5 = double("c5", value: 7, suit: :clubs)
      h = Hand.new([c1, c2, c3, c4, c5])
      expect(h.check_flush).to eq(0)
    end
  end

  describe '#check_straight' do
    it "returns the high of a simple straight" do
      c1 = double("c1", value: 4)
      c2 = double("c2", value: 6)
      c3 = double("c3", value: 5)
      c4 = double("c4", value: 8)
      c5 = double("c5", value: 7)
      h = Hand.new([c1, c2, c3, c4, c5])
      expect(h.check_straight).to eq(8)
    end

    it "returns the high of an ace high straight" do
      c1 = double("c1", value: 14)
      c2 = double("c2", value: 10)
      c3 = double("c3", value: 12)
      c4 = double("c4", value: 11)
      c5 = double("c5", value: 13)
      h = Hand.new([c1, c2, c3, c4, c5])
      expect(h.check_straight).to eq(14)
    end

    it "returns the high of an ace low straight" do
      c1 = double("c1", value: 14)
      c2 = double("c2", value: 3)
      c3 = double("c3", value: 2)
      c4 = double("c4", value: 5)
      c5 = double("c5", value: 4)
      h = Hand.new([c1, c2, c3, c4, c5])
      expect(h.check_straight).to eq(14)
    end

    it "returns 0 for uniq non-straight hands" do
      c1 = double("c1", value: 14)
      c2 = double("c2", value: 2)
      c3 = double("c3", value: 3)
      c4 = double("c4", value: 6)
      c5 = double("c5", value: 4)
      h = Hand.new([c1, c2, c3, c4, c5])
      expect(h.check_straight).to eq(0)
    end

    it "returns 0 for straights with double cards" do
      c1 = double("c1", value: 14)
      c2 = double("c2", value: 2)
      c3 = double("c3", value: 2)
      c4 = double("c4", value: 5)
      c5 = double("c5", value: 4)
      h = Hand.new([c1, c2, c3, c4, c5])
      expect(h.check_straight).to eq(0)
    end

  end
end
