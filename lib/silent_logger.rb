class SilentLogger < Logger
  
  def initialize
    super(STDOUT)
  end
  
  def add(severity, message = nil, progname = nil, &block)
    # shhh
  end
  
end