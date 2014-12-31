TrelloClone.Models.List = Backbone.Model.extend({

  urlRoot: "api/lists",

  initialize: function(opts) {
    this.board = opts.board;
  },

  cards: function() {

  },

  parse: function(resp) {

  }
})
