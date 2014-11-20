require 'game'
require 'game.rb'

describe Game do
  subject(:game) { Game.new }

  describe "set up" do
    it "creates a size 8x8 board as default" do
      expect(game.board.size).to eq(8)
    end

    it "fills the board as default" do

    end

  end

end
