require 'gibberish_trix'

ActiveRecord::Base.send!(:include, GibberishTrix::ActiveRecordExt)
ActionController::Base.send!(:include, GibberishTrix::ActionControllerExt)
