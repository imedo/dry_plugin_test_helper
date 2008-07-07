class SilentLogger < Logger
  
  def initialize
    super(STDOUT)
  end
  
  # adds log message
  # which will get swallowed
  def add(severity, message = nil, progname = nil, &block)
    # shhh
  end
  
end