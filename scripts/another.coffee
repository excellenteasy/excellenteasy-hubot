# Description:
#   Thor likes this drink!
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   another - Thor's "another" gif:
#
# Author:
#   boennemann

module.exports = (robot) ->
  robot.hear /another/i, (msg) ->
    msg.send "http://25.media.tumblr.com/tumblr_maor1rdrhm1rtstddo1_500.gif"
