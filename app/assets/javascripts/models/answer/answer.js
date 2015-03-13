KnowledgEase.Models.Answer = Backbone.Model.extend({
  // urlRoot: "/api/questions",

  author: function () {
    if (!this._author) {
      this._author = new KnowledgEase.Models.User
    }

    return this._author
  },

  parse: function (payload) {
    if (payload.author) {
      this.author().set(payload.author, {parse: true})
      delete payload.author
    }

    return payload
  },
})
