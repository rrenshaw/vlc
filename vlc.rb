

class Vlc
  def initialize
    # TODO put these into config file for easier config later
    @vlcpath='/usr/bin/vlc'
    @startarguments='--extraintf http --http-password=none'
  end

  def start
    system("#{vlcpath} #{startarguments} &")
  end
end

if $0 == __FILE__
  v=Vlc.new
  v.start
end
