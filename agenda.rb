require 'date'

# Modules
module Menu; end
module Promptable; end

# Classes
class Days
  def initialize(date, title)
    @date = date
    @title = title
    @all_sessions = []
  end
end
class Sessions 
  def initialize(time, title, description)
    @time = time
    @title = title
    @description = description
  end
end

if __FILE__ == $0
  day_1 = Days.new(DateTime.new(2016,11,01),"Day 1")
  session_1 = Sessions.new("13:15","Object Oriented Programming 101", "Learn about everyone's favourite programming paradigm!")
end