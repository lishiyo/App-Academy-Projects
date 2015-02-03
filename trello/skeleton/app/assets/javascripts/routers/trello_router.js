TrelloClone.Routers.TrelloRouter = Backbone.Router.extend({

  routes: {
    "": "boardsIndex",
    "boards/new": "boardNew",
    "boards/:id": "boardShow",
    "boards/:id/lists/new": "listNew"
  },

  initialize: function(opts) {
    this.$rootEl = opts.$rootEl;
  },

  boardsIndex: function(){
    this.$rootEl.empty();

    TrelloClone.boards = new TrelloClone.Collections.Boards();
    TrelloClone.boards.fetch();

    var boardsIndex = new TrelloClone.Views.BoardsIndex({
      collection: TrelloClone.boards
    });

    this._swapView(boardsIndex);
  },

  boardNew: function(){
    var board = new TrelloClone.Models.Board();
    TrelloClone.boards = new TrelloClone.Collections.Boards();
    TrelloClone.boards.fetch();

    var boardNew = new TrelloClone.Views.BoardNew({
      model: board,
      collection: TrelloClone.boards
    });

    this._swapView(boardNew);
  },

  boardShow: function(id) {
    TrelloClone.boards = new TrelloClone.Collections.Boards();
    TrelloClone.boards.fetch();

    var board = TrelloClone.boards.getOrFetch(id);
    // need to use success callback because board.lists() must be fetched

    board.fetch({
      success: function(){

        var boardShow = new TrelloClone.Views.BoardShow({
          model: board
        });

        this._swapView(boardShow);
      }.bind(this)
    });

  },

  listNew: function(boardId) {
    var board = TrelloClone.boards.getOrFetch(boardId);
    var list = new TrelloClone.Models.List({ board: board });

    var listNew = new TrelloClone.Views.ListNew({
      model: list,
      board: board
    });

    this._swapView(listNew);
  },

  _swapView: function(newView) {
    this._currentView && this._currentView.remove();
    this._currentView = newView;
    this.$rootEl.html(newView.render().$el);
  }


});
