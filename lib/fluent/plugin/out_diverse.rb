require 'fluent/output'
require 'fluent/config/error'
require 'fluent/event'

module Fluent
  class DiverseOutput < MultiOutput
    Plugin.register_output('diverse', self)

    desc 'Rate for minor directive output, for example: 0.03 => 3%'
    config_param :minor_rate, :float, default: 0.00

    def initialize
      super
    end

    attr_reader :outputs

    def configure(conf)
      super
      conf.elements.select {|e|
        e.name == 'major'
      }.each {|e|
        @major = output(e)
      }
      conf.elements.select {|e|
        e.name == 'minor'
      }.each {|e|
        @minor = output(e)
      }
    end

    def output(e)
      type = e['@type']
      unless type
        raise ConfigError, "Missing 'type' parameter on <major> or <minor> directive"
      end
      log.debug "adding type=#{type.dump}"

      output = Plugin.new_output(type)
      output.router = router
      output.configure(e)
      output
    end

    def start
      super
      @major.start if @major
      @minor.start if @minor
    end

    def shutdown
      @major.shutdown if @mejor
      @minor.shutdown if @minor
      super
    end

    def emit(tag, es, chain)
      unless es.repeatable?
        m = MultiEventStream.new
        es.each {|time,record|
          m.add(time, record)
        }
        es = m
      end
      if Random.new.rand < @minor_rate
        chain = OutputChain.new([@minor], tag, es, chain)
      else
        chain = OutputChain.new([@major], tag, es, chain)
      end
      chain.next
    end
  end
end
