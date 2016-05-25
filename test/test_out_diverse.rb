require 'test/unit'

require 'fluent/log'
require 'fluent/test'

require 'fluent/plugin/out_diverse'

class DiverseOutputTest < Test::Unit::TestCase

  setup do
    Fluent::Test.setup
    @tag = 'hello.world'
    @time = Fluent::Engine.now
  end

  def create_driver(conf, use_v1_config = true)
    Fluent::Test::OutputTestDriver.new(Fluent::DiverseOutput, @tag).configure(conf, use_v1_config)
  end

  sub_test_case 'configure' do
    test "asdf" do
      config = %[
        minor_rate 0.03
        <major>
            @type stdout
            name Major
        </major>
        <minor>
            @type stdout
            name Minor
        </minor>
      ]
      d = create_driver(config)

      d.run do
        d.emit({'foo' => 'bar'}, @time)
      end

      assert_equal(d.instance.minor_rate, 0.03)

      puts d.records
      puts d.events
      puts d.emits
      tag, time, record = d.emits.first
      assert_equal(@tag, tag)
    end

  end
end
