require 'test/unit'

require 'fluent/log'
require 'fluent/test'
require 'fluent/test'

require 'fluent/plugin/out_diverse'

Fluent::Test.setup

class DiverseOutputTest < Test::Unit::TestCase
  setup do
    @tag = 'hello.world'
    @time = Fluent::Engine.now
  end

  def create_driver(conf, use_v1_config = true)
    Fluent::Test::OutputTestDriver.new(Fluent::DiverseOutput, @tag).configure(conf, use_v1_config)
  end

  def emit(config)
    d = create_driver(config)
    d.run do
      d.emit({'foo' => 'bar'}, @time)
    end

    @instance = d.instance
    d.emits
  end

  sub_test_case 'configure' do
    test "asdf" do
      config = %[
        minor_rate 0.03
        <major>
            @type stdout
        </major>
        <minor>
            @type stdout
        </minor>
      ]
      emits = emit(config)
      tag, time, record = emits.first
      assert_equal(@tag, tag)
    end

  end
end
