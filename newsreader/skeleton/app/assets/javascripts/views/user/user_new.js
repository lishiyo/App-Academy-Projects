NewsReader.Views.UserNew = Backbone.View.extend({
  template: JST['user/new'],

  events: {
    "submit form": "createUser"
  },

  render: function () {
    var content = this.template({ user: this.model });
    this.$el.html(content);
    return this;
  },

  createUser: function (event){
    event.preventDefault();
    var formData = $(event.currentTarget).serializeJSON().user;

    this.model.save(formData, {
      success: function() {
        Backbone.history.navigate("", {trigger: true});
      }
    });
  }
})
