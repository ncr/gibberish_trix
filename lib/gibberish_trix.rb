module GibberishTrix
  
  module ActionControllerExt
    
    def self.included(base)
      base.around_filter :use_language
    end
    
    def use_language
      if !respond_to?(:current_language)
        Rails.logger.warn("GibberishTrix: Method #current_language not defined in ApplicationController")
        yield
      elsif current_language.blank?
        Rails.logger.warn("GibberishTrix: Method #current_languge returned blank")
        yield
      else
        Gibberish.use_language(current_language) do
          begin
            original_error_messages = ActiveRecord::Errors.default_error_messages
            ActiveRecord::Errors.default_error_messages = ActiveRecord::Errors.default_error_messages.inject({}) do |h, (key, string)|
              h.update(key => string["error_#{key}".to_sym])
            end
            yield
          ensure
            ActiveRecord::Errors.default_error_messages = original_error_messages
          end
        end
      end
    end

  end
  ActionController::Base.send!(:include, ActionControllerExt)
  
  module ActiveRecordExt

    def self.included(base)
      base.class_eval do
        class << self
          def human_attribute_name_with_localize(attribute_key_name)
            human_attribute_name_without_localize(attribute_key_name)["attr_#{table_name.singularize}_#{attribute_key_name}".to_sym]
          end
          alias_method_chain :human_attribute_name, :localize
        end
      end
    end

  end
  ActiveRecord::Base.send!(:include, ActiveRecordExt)
  
end
