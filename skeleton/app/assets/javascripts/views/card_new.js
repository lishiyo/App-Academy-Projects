TrelloClone.Views.CardNew = Backbone.View.extend({
  template: JST['cards/new'],

  initialize: function(opts){
    // this.list = opts.list;
  },

  events: {
    'submit form': "addCard"
  },

  render: function(){
    var content = this.template({ card: this.model });
    this.$el.html(content);
    return this;
  },

  addCard: function(event){
    event.preventDefault();
    var $form = $(event.currentTarget);
    var formData = $form.serializeJSON().card;
    formData['list_id'] = this.model.list.id;

    this.model.save(formData, {
      success: function(){
        this.model.list.cards().add(this.model);
        // attach subview in this.list
        this.model.list.cards().trigger('addNewCard', this.model);
        $form.remove();
      }.bind(this)
    });
  }
});
