require 'rubygems'
require 'active_support'
require 'active_record'

ENV['RAILS_ENV'] ||= 'sqlite3'

require File.dirname(__FILE__) + '/silent_logger'
require File.dirname(__FILE__) + '/plugin_test_environment'

require 'time'


# Code by Jay Fields
# http://blog.jayfields.com/2007/11/ruby-timeis.html
class Time
  def self.metaclass
    class << self; self; end
  end
  
  def self.is(point_in_time)
    new_time = case point_in_time
      when String then Time.parse(point_in_time)
      when Time then point_in_time
      else raise ArgumentError.new("argument should be a string or time instance")
    end
    class << self
      alias old_now now
    end
    metaclass.class_eval do
      define_method :now do
        new_time
      end
    end
    yield
    class << self
      alias now old_now
      undef old_now
    end
  end
end

