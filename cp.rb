#!/usr/bin/ruby

require 'childprocess'

process = ChildProcess.build('vlc', '--extraintf', 'http', '--http-password', 'none')
process.io.inherit!
process.start
p process.alive?
while process.alive?
  sleep 5
end
p process.exited?
p process.exit_code
