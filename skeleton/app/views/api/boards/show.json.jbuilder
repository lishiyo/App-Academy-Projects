# write some jbuilder to return some json about a board
# it should include the board
#  - its lists
#    - the cards for each list

json.extract! @board, :title, :id, :created_at, :updated_at, :user_id

json.lists do

  json.array! @board.lists do |json, list|
    json.title list.title
    json.id list.id
    json.ord list.ord
    json.board_id list.board_id

      json.cards list.cards do |json, card|
        json.title card.title
        json.description card.description
        json.ord card.ord
        json.list_id card.list_id
        json.id card.id
      end

  end

end
