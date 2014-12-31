TrelloClone.Views.ListShow = Backbone.CompositeView.extend({
  tagName: "li",

  className: "list-show",

  template: JST["lists/show"],

  initialize: function() {
    this.listenTo(this.model, 'sync', this.render);
    this.listenTo(this.model.cards(), 'sync add remove', this.render);

    this.listenTo(this.model.cards(), 'addNewCard', this.addCardSubview);

    this.model.cards().each(function(card){
      this.addCardSubview(card);
    }.bind(this));

  },

  events: {
    'click .open-card-form': "openCardForm"
  },

  addCardSubview: function(card){
    var cardSubview = new TrelloClone.Views.CardShow({
      model: card
    });
    console.log(card);
    this.addSubview("ul.all-cards", cardSubview);
  },

  openCardForm: function(event) {
    event.preventDefault();
    var card = new TrelloClone.Models.Card({
      list: this.model
    });
    var cardFormView = new TrelloClone.Views.CardNew({
      model: card
    });
    var $div = $('<div>').addClass('new-card-view');
    $div.html(cardFormView.render().$el);
    this.$el.prepend($div);
  },

  render: function () {
    var content = this.template({
      list: this.model
    });
    this.$el.html(content);

    this.attachSubviews();

    return this;
  }

})
