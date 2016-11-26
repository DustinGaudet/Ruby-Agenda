require 'date'

## Modules ##
module Menu
  def menu
    "-----------------------------------------------
Please select an option from the following menu:
1) Add session
2) Show sessions (long)
3) Show sessions (short)
4) Sort sessions by time
Q) Quit"
  end
  def show
    menu
  end
end
module Promptable
  def prompt(message = "Please choose an action.", symbol = ":> ")
    puts message
    print symbol
    gets.chomp
  end
end

## Classes ##
# TODO: Add Agendas class
# TODO: Add Speakers class
class Days 
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
    all_sessions << session
  end
  def show_sessions 
    all_sessions
  end
  def sort_by_time
    all_sessions.sort! {|a, b| a.time <=> b.time}
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
  sample_time1 = DateTime.strptime("02:00 PM", "%I:%M %p")
  sample_time2 = DateTime.strptime("07:00 AM", "%I:%M %p")
  day_1.add_session(Sessions.new(sample_time1, "After Lunch Session", "A lovely afternoon session."))
  day_1.add_session(Sessions.new(sample_time2, "Morning Session", "A lovely morning session."))
  include Menu
  include Promptable
  until ["q"].include?(user_input = prompt(show).downcase)
    case user_input
    when "1"
      # TODO: Sanitize the time input. It needs to be consistent for later sorting.
      set_time = DateTime.strptime(prompt("What time is the session? (Format: HH:MM _M)"), "%I:%M %p")
      set_title = prompt("What is the session title?")
      set_description = prompt("What is the session description?")
      day_1.add_session(Sessions.new(set_time, set_title, set_description))
    when "2"
      day_1.show_sessions.each do |session|
        time = session.time.strftime('%I:%M %p')
        puts "--------------"
        puts "#{time} - #{session.title}\n\n"
        puts "• #{session.description} \n\n"
      end
    when "3"
      day_1.show_sessions.each.with_index do |session, i|
        time = session.time.strftime('%I:%M %p')
        sess_num = (i + 1).to_s
        puts "#{sess_num}) #{time} - #{session.title}"
      end
    when "4"
      day_1.sort_by_time
    else 
      puts "That is not an option."
    end  
  end
  puts "Thanks for using the Agenda Builder program!\n\n"
end