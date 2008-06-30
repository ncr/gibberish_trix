require 'test/unit'

# these are needed for bang version of #send (which will is not part of Ruby 1.8)
require 'rubygems'
require 'active_support'

# we need to check if our monkeypatching is sane
require 'active_record'

require 'gibberish_trix'

class GibberishTrixTest < Test::Unit::TestCase
  
  class ActionControllerStub
    def self.around_filter *args
    end
  end
  
  class ActiveRecordStub
    def self.human_attribute_name *args
    end
  end

  def test_action_controller_ext
    assert_nothing_raised { ActionControllerStub.send!(:include, GibberishTrix::ActionControllerExt) }
  end

  def test_active_record_ext
    assert_nothing_raised { ActiveRecordStub.send!(:include, GibberishTrix::ActiveRecordExt) }
  end
  
  def test_monkey_patching_is_sane
    assert ActiveRecord::Base.human_attribute_name("something").is_a?(String)
  end

end
