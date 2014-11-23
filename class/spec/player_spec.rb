require 'rspec'
require 'player'

describe Player do
  subject(:player) { Player.new("Genghis", 100) }

  it "assigns the name" do
    expect(player.name).to eq("Genghis")
  end

  it "assigns the starting money" do
    expect(player.money).to eq(100)
  end

  describe "#pay_winnings" do

    it "adds to winnings" do
      player.pay_winnings(20)
      expect(player.money).to eq(120)
    end

  end

  describe '#parse_discard' do

    it 'gets the card indexes player wants to discard' do
      expect(player.parse_discard("2 4")).to eq([2, 4])
    end

    it 'allows player to choose not to discard' do
      expect(player.parse_discard("")).to eq([])
    end

    it 'raises error for more than 3 cards' do
      expect do
        player.parse_discard("1 2 3 4")
      end.to raise_error(BadInputError)
    end

    it 'raises error for card index outside of 1-5' do
      expect do
        player.parse_discard("7")
      end.to raise_error(BadInputError)
    end

    it 'raises error for garbage input' do
      expect do
        player.parse_discard("i dont like u rspeccccccc")
      end.to raise_error(BadInputError)
    end

  end

  describe '#parse_move' do

    it "gets the player choice of 'fold'" do
      expect(player.parse_move("f")).to eq(:fold)
    end

    it "gets the player choice of 'see'" do
      expect(player.parse_move("s")).to eq(:see)
    end

    it "gets the player choice of 'raise'" do
      expect(player.parse_move("r")).to eq(:raise)
    end

    it 'raises error for any input besides fold/see/raise' do
      expect do
        player.parse_move("1 2 3")
      end.to raise_error(BadInputError)
    end

  end

  describe '#parse_bet' do

    it "gets the player's bet amount" do
      expect(player.parse_bet("50")).to eq(50)
    end

    it 'raises error for a bet higher than their money' do
      expect do
        player.parse_bet("200")
      end.to raise_error(BadInputError)
    end

    it 'raises error for garbage input' do
      expect do
        player.parse_bet("arargahrgrrrhhhh")
      end.to raise_error(BadInputError)
    end

  end

  describe '#take_bet' do

    it "takes bet amount from player's money" do
      player.take_bet(20)
      expect(player.money).to eq(80)
    end

  end

end
