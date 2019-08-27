#!/usr/bin/ruby

require 'json'
require 'rest-client'
require 'childprocess'

class Vlc
  def initialize
    # TODO put these into config file for easier config later
    vlcpath='/usr/bin/vlc'
    @pw=[*('A'..'Z'),*('a'..'z'),*('0'..'9')].shuffle[0,16].join
    @vlcproc=ChildProcess.build(vlcpath, '--extraintf', 'http', '--http-password', @pw)
    # @vlcproc.io.inherit!
  end

  def start
    # p system("#{@vlcpath} #{@startarguments} &")
    @vlcproc.start
  end

  def playlist
    # playlist = system("/usr/bin/curl -u:none http://localhost:8080/requests/playlist.json")
    pl=[]
    rc=RestClient::Resource.new 'http://localhost:8080/requests/playlist.json', '', @pw
    res = JSON.parse(rc.get)
    res['children'].each do |k, v|
      if k['name'] == 'Playlist'
        print "K: #{k} --> #{v}\n"
        pl=v
      end
    end
    pl
  end

  def status
    # status = system("/usr/bin/curl -u:none http://localhost:8080/requests/status.json")
    rc=RestClient::Resource.new 'http://localhost:8080/requests/status.json', '', @pw
    res = JSON.parse(rc.get)
    res.each do |k, v|
      print "K: #{k} -> #{v}\n"
    end
  end

  def addTrack(filename)
    # > add <uri> to playlist:
    #   ?command=in_enqueue&input=<uri>
    if File.exist?(filename)
      file_uri = "file://#{filename}"
      rc=RestClient::Resource.new "http://localhost:8080/requests/status.json?command=in_enqueue&input=#{file_uri}", '', @pw
      rc.get
    else
      print "#{filename} not found"
    end
  end

  def play #TODO add optional track # IDEA:
    rc=RestClient::Resource.new 'http://localhost:8080/requests/status.json?command=pl_play', '', @pw
    rc.get
  end

end

if $0 == __FILE__
  v=Vlc.new
  v.start
  sleep(3)
  print "Status:\n"
  v.status
  v.addTrack('/home/rick/Videos/Bully/bully.iso')
  print "\nPlaylist:\n"
  p v.playlist
  v.play
  v.status
end
