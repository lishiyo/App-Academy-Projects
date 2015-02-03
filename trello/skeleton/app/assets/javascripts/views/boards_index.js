TrelloClone.Views.BoardsIndex = Backbone.View.extend({

  template: JST['boards/index'],

  events: {
    'click .deleteBoard': "deleteBoard"
  },

  initialize: function(){
    this.listenTo(this.collection, 'sync destroy', this.render);
  },

  render: function(){
    var content = this.template({ boards: this.collection });
    this.$el.html(content);
    return this;
  },

  addNewBoardSubview: function(board) {

  },

  addBoardSubview: function(event) {

  },

  deleteBoard: function(event) {
    event.preventDefault();
    var boardId = $(event.currentTarget).data("id");
    var board = this.collection.get(boardId);
    board.destroy();
  }

})
