TrelloClone.Views.CardShow = Backbone.CompositeView.extend({
  tagName: "li",

  className: "card-show",

  template: JST["cards/show"],

  initialize: function() {

  },

  events: {
    'click .delete-card': 'deleteCard'
  },

  render: function(){
    var content = this.template({
      card: this.model
    });
    this.$el.html(content);

    return this;
  },

  deleteCard: function(e) {
    e.preventDefault();
    var card = new TrelloClone.Models.Card({id: this.model.id});
    card.destroy();

    this.$el.remove();
  }

});
