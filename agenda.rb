require 'date'

## Modules ##
module Menu
  def menu
    "-----------------------------------------------
Please select an option from the following menu:
1) Add session
2) Show sessions (long)
3) Show sessions (short)
4) Update Session
5) Delete session
6) Sort sessions by time
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
module Sanitizable
  def sanitize(the_input) # Extremely basic, to avoid conflict between user input and delimiter
    the_input.to_s.gsub(/:/, ":0")
  end
  def desanitize(the_input)
    the_input.gsub(/:0/, ":")
  end
end

## Classes ##
# TODO: Add Agendas class
# TODO: Add Speakers class
class Days 
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
  def update_session(number, new_sess)
    index = Integer(number) - 1
    all_sessions[index] = new_sess
  end
  def delete_session(number)
    index = Integer(number) - 1
    all_sessions.delete_at(index)
  end
  def sort_by_time
    all_sessions.sort! {|a, b| a.time <=> b.time}
  end
end
class Sessions 
  # TODO: Add speakers to session

  include Sanitizable

  attr_reader :time
  attr_reader :title
  attr_reader :description

  def initialize(time, title, description) 
    @time = sanitize(time)
    @title = sanitize(title)
    @description = sanitize(description)
  end
  def dstime
    DateTime.parse(desanitize(time))
  end
  def dstitle
    desanitize(title)
  end
  def dsdescription
    desanitize(description)
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
  include Sanitizable
  until ["q"].include?(user_input = prompt(show).downcase)
    case user_input
    when "1" # Add
      # TODO: Sanitize the time input. It needs to be consistent for later sorting.
      set_time = DateTime.strptime(prompt("What time is the session? (Format: HH:MM _M)"), "%I:%M %p")
      set_title = prompt("What is the session title?")
      set_description = prompt("What is the session description?")
      day_1.add_session(Sessions.new(set_time, set_title, set_description))
    when "2" # Show Long
      day_1.show_sessions.each do |session|
        time = session.dstime.strftime('%I:%M %p')
        puts "--------------"
        puts "#{time} - #{session.dstitle}\n\n"
        puts "• #{session.dsdescription} \n\n"
      end
    when "3" # Show Short
      day_1.show_sessions.each.with_index do |session, i|
        time = session.dstime.strftime('%I:%M %p')
        sess_num = (i + 1).to_s
        puts "#{sess_num}) #{time} - #{session.dstitle}"
      end
    when "4" # Update
      # TODO: Add submenu to specify which part of session to update
      day_1.show_sessions.each.with_index do |session, i|
        time = session.dstime.strftime('%I:%M %p')
        sess_num = (i + 1).to_s
        puts "#{sess_num}) #{time} - #{session.dstitle}"
      end
      sess_updating = prompt("Enter the number of the session you wish to update.")
      set_time = DateTime.strptime(prompt("What should be the updated session time? (Format: HH:MM _M)"), "%I:%M %p")
      set_title = prompt("What should be the updated session title?")
      set_description = prompt("What should be the updated session description?")
      new_sess = Sessions.new(set_time, set_title, set_description)
      day_1.update_session(sess_updating, new_sess)
    when "5" # Delete
      day_1.show_sessions.each.with_index do |session, i|
        time = session.dstime.strftime('%I:%M %p')
        sess_num = (i + 1).to_s
        puts "#{sess_num}) #{time} - #{session.dstitle}"
      end
      day_1.delete_session(prompt("Enter the number of the session you would like to delete."))
    when "6" # Sort by Time
      day_1.sort_by_time
    else 
      puts "That is not an option."
    end  
  end
  puts "Thanks for using the Agenda Builder program!\n\n"
end