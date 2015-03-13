KnowledgEase.Models.Question = Backbone.Model.extend({
  urlRoot: "/api/questions",

  author: function () {
    if (!this._author) {
      this._author = new KnowledgEase.Models.User
    }

    return this._author
  },

  askers: function () {
    if (!this._askers) {
      this._askers = new KnowledgEase.Collections.Users
    }

    return this._askers
  },

  answers: function () {
    if (!this._answers) {
      this._answers = new KnowledgEase.Collections.Answers
    }
    return this._answers
  },

  parse: function (payload) {
    if (payload.author) {
      this.author().set(payload.author, {parse: true})
      delete payload.author
    }

    if (payload.askers) {
      this.askers().set(payload.askers, {parse: true})
      delete payload.askers
    }

    if (payload.answers) {
      this.answers().set(payload.answers, {parse: true})
      delete payload.answers
    }

    console.log (this.answers().models[0].author())

    return payload
  },

  toJSON: function (options) {
    return {question: _.clone(this.attributes)}
  }
})
