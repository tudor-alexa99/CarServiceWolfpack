require_relative 'time_interval'

class Service
  # Since 2 processes can take place at the same time, save them in different time schedules
  # If they overlap, the time window is unavailable
  #
  # For each process, keep track of the ending time. Each time a new car is added, increase the lowest ending time

  # case Time.now.

  OPEN_FROM_WEEKDAY = "8:30"
  CLOSE_AT_WEEKDAY = "16:30"

  OPEN_FROM_WEEKEND = "10:00"
  CLOSE_AT_WEEKEND = "14:00"

  def initialize
    # check the current day and set the closing time regarding week time and weekend hours
    starting_hours, ending_hours = get_daily_working_hours

    @today_opening_time = Time.new(Time.now.year, Time.now.month, Time.now.day, starting_hours[0], starting_hours[1])
    @today_closing_time = Time.new(Time.now.year, Time.now.month, Time.now.day, ending_hours[0], ending_hours[1])
    # list of all the reserved timestamps


    worker_1 = next_available_interval
    worker_2 = next_available_interval
  end


  def get_daily_working_hours()
    case Time.now.strftime("%A")
    when "Saturday"
      return OPEN_FROM_WEEKEND.split(":"), CLOSE_AT_WEEKEND.split(":")
    when "Sunday"
      return [0, 0], [0, 0]
    else
      return OPEN_FROM_WEEKDAY.split(":"), CLOSE_AT_WEEKDAY.split(":")
    end

  end

  def add_reservation() end

  def next_available_interval
    # method that takes into account the day and time and gives the next available hour a car can be programmed
    nil
  end

end

# TODO: salveaza 2 variabile, fiecare reprezinta pana cand e ocupat un moncitor
# TODO: Metoda de cautat care e prima ora disponibila
# TODO: Metoda care calculeaza cand primesti masina inapoi

service = Service.new
