class SendToBrowser
  def self.call(command, **args)
    new(command, **args).call
  end

  def initialize(command, **args)
    @command, @args = command, args
  end

  def call
    args = { command: @command }.merge(@args)
    ActionCable.server.broadcast(CastChannel::NAME, args)
  end
end
