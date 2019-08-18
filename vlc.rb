#!/usr/bin/ruby

require 'json'

class Vlc
  def initialize
    # TODO put these into config file for easier config later
    @vlcpath='/usr/bin/vlc'
    @startarguments='--extraintf http --http-password=none'
  end

  def start
    system("#{@vlcpath} #{@startarguments} &")
  end

  def playlist
    playlist = system("/usr/bin/curl -u:none http://localhost:8080/requests/playlist.json")
    # p playlist
  end

  def status
    status = system("/usr/bin/curl -u:none http://localhost:8080/requests/status.json")
  end

end

if $0 == __FILE__
  v=Vlc.new
  v.start
  sleep(3)
  v.status
  v.playlist
end
