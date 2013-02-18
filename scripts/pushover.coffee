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

pushMsg = (user, options) ->
  users[user].send options, (err, result) ->

# "#{msg.message.user.name}@#{msg.message.user.room}"

module.exports = (robot) ->
  robot.hear /.*/, (msg) ->
    id       = msg.message.user.id
    room     = msg.message.user.room
    text     = msg.message.text
    username = msg.message.user.name
    # don't listen on hubot calls
    return if /^hubot/.test(text)
    # pusherover payload
    options =
      message: text
      sound: 'pushover'
      title: "#{username} about #{room}"

    # strip away html
    if username is 'GitHub' or username is 'Circle'
      $ = cheerio.load "<body><span>#{text}</span></body>"
      options.message  = $('span').text()

    if username is 'Circle'
      tmpTitle = "#{room} #{text.match(/#[0-9]+/)[0]}"
      switch text.match(/Failed|Fixed|Success/)[0]
        when 'Fixed', 'Success'
          options.title = "\u2705 #{tmpTitle}"
          options.sound = 'bugle'
        when 'Failed'
          options.title = "\u26D4 #{tmpTitle}"
          options.sound = 'siren'

      # strip away redundant information
      # regex: $status in build #$number of $user/$repo ($branch)
      options.message = options.message.replace(
        /(Failed|Success|Fixed)\sin\sbuild\s#[0-9]+\sof\s[A-Za-z0-9\_\-]+\/[A-Za-z0-9\_\-]+\s\([A-Za-z0-9\_\-]+\)\s*/,
        '')

    # look at user ids to not push a user his/her own message
    unless id is '169564' and /^boennemann/.test(text)
      pushMsg 'stephan', options
    unless id is '169566' and /^davidpfahler/.test(text)
      pushMsg 'david', options
