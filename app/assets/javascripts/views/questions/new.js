KnowledgEase.Views.NewQuestion = Backbone.CompositeView.extend({
  initialize: function (options) {
  },

  template: JST['questions/form'],

  events: {
    "submit .question-form": "createQuestion"
  },

  render: function () {
    this.$el.html(this.template({question: this.model}));

    return this;
  },

  createQuestion: function (event) {
    event.preventDefault();
    var attrs = $(event.currentTarget).serializeJSON()
    this.model.save(attrs, {
      success: function () {
        this.collection.add(this.model)
        this.model = new KnowledgEase.Models.Question
        this.render()
      }.bind(this)
    })
  }
})