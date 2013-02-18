# Description:
#   A script sending every message directly to PushOver
#
# Commands:
#   every fucking message
#
# Dependencies:
#   "pushover-notifications": "0.1.2"
#
# Configuration:
#   PUSHOVER_TOKEN
#   PUSHOVER_STEPHAN
#   PUSHOVER_DAVID
#
# Commands:
#   every fucking message
#
# Notes:
#   none
#
# Author:
#   boennemann

Push    = require 'pushover-notifications'
cheerio = require 'cheerio'

users =
  stephan: new Push
    user: process.env['PUSHOVER_STEPHAN']
    token: process.env['PUSHOVER_TOKEN']
  david: new Push
    user: process.env['PUSHOVER_DAVID']
    token: process.env['PUSHOVER_TOKEN']

pushMsg = (msg, user, title) ->
  users[user].send
    message: msg.message.text
    title: title or "#{msg.message.user.name}@#{msg.message.user.room}"
  , (err, result) ->

module.exports = (robot) ->
  robot.hear /.*/, (msg) ->
    text = msg?.message?.text

    # don't listen on hubot calls
    return if /^hubot/.test(text)

    # massage message if contains html
    if msg.message.user.name is 'GitHub' or msg.message.user.name is 'Circle'
      $ = cheerio.load "<body><span>#{text}</span></body>"
      msg.message.text = $('span').text()

    title = null
    if msg.message.user.name is 'Circle'
      title = "#{msg.message.user.room} #{text.match(/#[0-9]*/)[0]}"
      switch text.match(/Failed|Fixed|Success/)[0]
        when 'Fixed', 'Success'
          title = "\ue21a #{title}"
        when 'Failed'
          title = "\ue219 #{title}"

    # look at user ids to not push a user his/her own message
    id = msg?.message?.user?.id
    if id isnt '169564' and not /^boennemann/.test(text)
      pushMsg msg, 'stephan', title
    if id isnt '169566' and not /^davidpfahler/.test(text)
      pushMsg msg, 'david', title