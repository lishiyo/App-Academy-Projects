TrelloClone.Models.Card = Backbone.Model.extend({

  urlRoot: "api/cards",

  initialize: function(opts) {
    this.list = opts.list;
  }

})
