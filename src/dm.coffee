Message = require './message'

class DM
  constructor: (@_client, data = {}) ->
    @_typing = {}
    @_history = {}

    for k of (data or {})
      @[k] = data[k]

    # Set a name on this channel for consistency
    if @user
      u = @_client.getUserByID @user
      if u
        @name = u.name

  addMessage: (message) ->
    @_history[message.ts] = message

  getHistory: ->
    @_history

  startedTyping: (user_id) ->
    # Start timer to clear this
    if @_typing[user_id] then clearTimeout @_typing[user_id]
    @_typing[user_id] = setTimeout @_typingTimeout, 5000, user_id

  _typingTimeout: (user_id) =>
    delete @_typing[user_id]

  getTyping: ->
    for k of @_typing
      k

  send: (text) ->
    m = new Message @_client, {text: text}
    @sendMessage m

  sendMessage: (message) ->
    message.channel = @id
    @_client._send(message)

module.exports = DM