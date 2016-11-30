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
5) Add speaker to session
6) Delete session
7) Sort sessions by time
8) Write to File
9) Read from File
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
  def sanitize(the_input) # Extremely basic, to avoid conflict between user input and "::" delimiter
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
  def write_to_file(filename)
    # TODO: Check if file exists already. Warn if it does.
    machine_format_list = all_sessions.map(&:to_machine).join("\n")
    IO.write(filename, machine_format_list)
  end
  def load_from_file(filename)
    all_sessions.clear
    IO.readlines(filename).each do |line|
      sess_data = line.split('::')
      sess_time = sess_data[0]
      sess_title = sess_data[1]
      sess_descr = sess_data[2]
      add_session(Sessions.new(sess_time, sess_title, sess_descr, true))
    end
  end
end
class Sessions 
  # TODO: Add speakers to session

  include Sanitizable

  attr_reader :time
  attr_reader :title
  attr_reader :description
  attr_reader :all_speakers

  def initialize(time, title, description, from_file = false) 
    @time = from_file ? DateTime.iso8601(desanitize(time)) : DateTime.strptime(time, "%I:%M %p")
    @title = from_file ? desanitize(title) : title
    @description = from_file ? desanitize(description) : description
    @all_speakers = []
  end

  def add_speaker(speaker)
    all_speakers << speaker
  end
  
  def to_machine
    sn_time = sanitize(time)
    sn_title = sanitize(title)
    sn_descr = sanitize(description)
    "#{sn_time}::#{sn_title}::#{sn_descr}"
  end
end
class Speakers
  attr_reader :name
  attr_reader :tag
  attr_reader :job_title
  attr_reader :company

  def initialize(name, job_title, company, tag)
    @name = name
    @job_title = job_title
    @company = company
    @tag = tag
  end
end

if __FILE__ == $0
  day_1 = Days.new(DateTime.new(2016,11,01),"Day 1")
  sample_time1 = "02:00 PM"
  sample_time2 = "07:00 AM"
  day_1.add_session(Sessions.new(sample_time1, "After Lunch Session", "A lovely afternoon session."))
  day_1.add_session(Sessions.new(sample_time2, "Morning Session", "A lovely morning session."))
  include Menu
  include Promptable
  include Sanitizable
  until ["q"].include?(user_input = prompt(show).downcase)
    case user_input
    when "1" # Add
      # TODO: Sanitize the time input. It needs to be consistent for later sorting.
      set_time = prompt("What time is the session? (Format: HH:MM _M)")
      set_title = prompt("What is the session title?")
      set_description = prompt("What is the session description?")
      day_1.add_session(Sessions.new(set_time, set_title, set_description))
    when "2" # Show Long
      day_1.show_sessions.each do |session|
        time = session.time.strftime('%I:%M %p')
        puts "--------------"
        puts "#{time} - #{session.title}\n\n"
        puts "• #{session.description} \n\n"
        session.all_speakers.each do |speaker|
          puts "| #{speaker.name} [#{speaker.tag}]"
          puts "| #{speaker.job_title}"
          puts "| #{speaker.company}\n\n"
        end
      end
    when "3" # Show Short
      day_1.show_sessions.each.with_index do |session, i|
        time = session.time.strftime('%I:%M %p')
        sess_num = (i + 1).to_s
        puts "#{sess_num}) #{time} - #{session.title}"
      end
    when "4" # Update
      # TODO: Add submenu to specify which part of session to update
      day_1.show_sessions.each.with_index do |session, i|
        time = session.time.strftime('%I:%M %p')
        sess_num = (i + 1).to_s
        puts "#{sess_num}) #{time} - #{session.title}"
      end
      sess_updating = prompt("Enter the number of the session you wish to update.")
      set_time = prompt("What should be the updated session time? (Format: HH:MM _M)")
      set_title = prompt("What should be the updated session title?")
      set_description = prompt("What should be the updated session description?")
      new_sess = Sessions.new(set_time, set_title, set_description)
      day_1.update_session(sess_updating, new_sess)
    when "5" # Add Speaker
      # TODO: Prevent the program from crashing when input not an integer
      day_1.show_sessions.each.with_index do |session, i|
        time = session.time.strftime('%I:%M %p')
        sess_num = (i + 1).to_s
        puts "#{sess_num}) #{time} - #{session.title}"
      end
      sess_num = Integer(prompt("Please select a session to add the speaker to.")) - 1 
      spkr_name = prompt("Please enter the speaker's full name.")
      spkr_title = prompt("Please enter the speaker's job title.")
      spkr_company = prompt("Please enter the speaker's company name.")
      spkr_tag = ""
      if ['y'].include?(prompt("Do you want to add a special tag? [y/n]").downcase)
        spkr_tag << prompt("What would you like the tag to say?")
      end
      day_1.all_sessions[sess_num].add_speaker(Speakers.new(spkr_name, spkr_title, spkr_company, spkr_tag))
      puts "#{spkr_name} added to session #{sess_num} successfully!"
    when "6" # Delete
      day_1.show_sessions.each.with_index do |session, i|
        time = session.time.strftime('%I:%M %p')
        sess_num = (i + 1).to_s
        puts "#{sess_num}) #{time} - #{session.title}"
      end
      day_1.delete_session(prompt("Enter the number of the session you would like to delete."))
    when "7" # Sort by Time
      day_1.sort_by_time
    when "8" # Write to File
      day_1.write_to_file(prompt("Please enter the filename below. Filename will be appended with '.txt'.") + ".txt")
    when "9" # Load from File
      if prompt("Loading from file will erase this day's current sessions. Continue? [y/n]").downcase == "y"
        day_1.load_from_file(prompt("Please enter the filename, without extension, below.") + ".txt")
      else
        puts "File was not loaded."
      end
    else 
      puts "That is not an option."
    end  
  end
  puts "Thanks for using the Agenda Builder program!\n\n"
end