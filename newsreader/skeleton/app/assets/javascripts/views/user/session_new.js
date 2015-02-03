NewsReader.Views.SessionNew = Backbone.View.extend({
  template: JST['user/session'],

  events: {
    "submit form": "createSession"
  },

  render: function () {
    var content = this.template({ session: this.model });
    this.$el.html(content);
    return this;
  },

  createSession: function (event){
    event.preventDefault();
    var formData = $(event.currentTarget).serializeJSON().user;

    this.model.save(formData, {
      success: function() {
        Backbone.history.navigate("/users/" + this.model.id, {trigger: true});
      }.bind(this)
    });
  }
})
