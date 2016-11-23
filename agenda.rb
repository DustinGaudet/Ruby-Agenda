require 'date'

## Modules ##
# TODO: Set these up so the program can be tested interactively
module Menu; end
module Promptable; end

## Classes ##
# TODO: Add Agendas class
# TODO: Add Speakers class
class Days 
  # TODO: Sort all_sessions by time
  # TODO: delete_session method
  # TODO: update_session method
  # TODO: write_to_file method
  # TODO: read_from_file method
  attr_reader :all_sessions

  def initialize(date, title)
    @date = date
    @title = title
    @all_sessions = []
  end
  def add_session(session)
    @all_sessions << session
  end
  def show_sessions 
    # TODO: option to show only session times/titles, for easier nav when editing agenda
    # TODO: display sessions with numbers for easier selection
    all_sessions
  end
end
class Sessions 
  # TODO: Add speakers to session
  attr_reader :time
  attr_reader :title
  attr_reader :description

  def initialize(time, title, description) 
    @time = time
    @title = title
    @description = description
  end
end

if __FILE__ == $0
  day_1 = Days.new(DateTime.new(2016,11,01),"Day 1")
  day_1.add_session(Sessions.new("13:15","Object Oriented Programming 101", "Learn about everyone's favourite programming paradigm!"))
  day_1.add_session(Sessions.new("14:00","Test Driven Development", "Learn how to troubleshoot WHILE you code, instead of after!"))
  day_1.show_sessions.each do |session|
    puts "--------------"
    puts session.time << " - " << session.title << "\n\n"
    puts "• " << session.description << "\n\n"
  end
end