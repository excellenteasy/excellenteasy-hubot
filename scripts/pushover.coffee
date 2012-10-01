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

Push = require 'pushover-notifications'

users
  stephan: new Push
    user: process.env['PUSHOVER_STEPHAN']
    token: process.env['PUSHOVER_TOKEN']
  david: new Push
    user: process.env['PUSHOVER_DAVID']
    token: process.env['PUSHOVER_TOKEN']

pushMsg = (msg, user) ->
  users[user].send
    message: msg.message.text
    title: "#{msg.message.user.name}@#{msg.message.user.room}"
  , (err, result) ->

module.exports = (robot) ->
  robot.hear /.*/, (msg) ->
    if msg.message.user.id isnt '169564'
      pushMsg msg, 'stephan'
    if msg.message.user.id isnt '169566'
      pushMsg msg, 'david'


