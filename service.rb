require_relative 'time_interval'

class Service
  # Since 2 processes can take place at the same time, save them in different time schedules
  # If they overlap, the time window is unavailable
  #
  # For each process, keep track of the ending time. Each time a new car is added, increase the lowest ending time


  OPEN_FROM_WEEKDAY = "8:30"
  CLOSE_AT_WEEKDAY = "16:30"

  OPEN_FROM_WEEKEND = "10:00"
  CLOSE_AT_WEEKEND = "14:00"


  attr_accessor :worker_1_available, :worker_2_available


  def initialize
    # check the current day and set the closing time regarding week time and weekend hours
    @starting_hours, @ending_hours = get_daily_working_hours

    @worker_1_available = @starting_hours.dup # make a dup
    @worker_2_available = @starting_hours.dup
  end

  def get_daily_working_hours(day = Time.now)
    day = day.strftime("%A")
    case day
    when "Saturday"
      return Time.new(Time.now.year,
                      Time.now.month,
                      Time.now.day,
                      OPEN_FROM_WEEKEND.split(":")[0],
                      OPEN_FROM_WEEKEND.split(":")[1]),
          Time.new(Time.now.year,
                   Time.now.month,
                   Time.now.day,
                   CLOSE_AT_WEEKEND.split(":")[0],
                   CLOSE_AT_WEEKEND.split(":")[1])
    when "Sunday"
      return [0, 0], [0, 0] # we'll see if this is any useful
    else
      return Time.new(Time.now.year,
                      Time.now.month,
                      Time.now.day,
                      OPEN_FROM_WEEKDAY.split(":")[0],
                      OPEN_FROM_WEEKDAY.split(":")[1]),
          Time.new(Time.now.year,
                   Time.now.month,
                   Time.now.day,
                   CLOSE_AT_WEEKDAY.split(":")[0],
                   CLOSE_AT_WEEKDAY.split(":")[1])
    end

  end

  def add_reservation()
    # get the first available worker, i.e. the closest time a worker can take the car
    available_time = first_available_worker
    process_car(available_time)
  end

  def first_available_worker
    # method that returns the first available time for a car to be processed
    # Make sure the time they are available is >= than the current time
    # If not, set their values to the current time
    @worker_1_available = Time.now if @worker_1_available < Time.now
    @worker_2_available = Time.now if @worker_2_available < Time.now

    [@worker_1_available, @worker_2_available].min { |a, b| a <=> b }
  end

  def process_car(available_time)
    # take the first available time and returns the time when the car will be done
    process_car_time = available_time.dup + 2 * 60 * 60 # convert seconds into hours, add 2 hours

    # get the closing hours for that day
    closing_hours = get_daily_working_hours(process_car_time)[1]

    # if the car cannot be processed within the day, move it to the next available day
    if closing_hours < process_car_time
      extra_time = process_car_time - closing_hours
      return process_next_day(extra_time, process_car_time)
    else
      # I know the returns are redundant, I added them to emphasise that the value will be used outside
      return process_today(process_car_time)
    end
  end

  def process_today(process_car_time)
    # Set the first available worker to take care of the car, increase the available time value
    set_available_worker(process_car_time)
    return [worker_1_available, @worker_2_available].max
  end

  def process_next_day(extra_time, process_car_time)
    # check if the following day is not a Sunday, and get the next available day if so
    next_day = get_daily_working_hours(process_car_time + 1 * 24 * 3600)
    if next_day.strftime("%A") == "Sunday"
      next_day = get_daily_working_hours(process_car_time + 2 * 24 * 3600)
    end

    available_worker = [@worker_1_available, @worker_2_available].min
    available_worker = next_day + extra_time
    # [@worker_1_available, @worker_2_available].min = available_worker <== for some reason, this does not work
    set_available_worker(process_car_time)
    # the pick-up time will be this one
    return [@worker_1_available, @worker_2_available].max
  end

  def set_available_worker(process_car_time)
    if @worker_1_available < @worker_2_available
      @worker_1_available = process_car_time
    else
      @worker_2_available = process_car_time
    end
  end

end

# TODO: salveaza 2 variabile, fiecare reprezinta pana cand e ocupat un moncitor
# TODO: Metoda de cautat care e prima ora disponibila
# TODO: Metoda care calculeaza cand primesti masina inapoi

service = Service.new
puts service.first_available_worker

puts "Working hours: "
puts service.get_daily_working_hours(Time.now + 3 * 24 * 3600)
puts service.add_reservation
puts service.add_reservation
puts service.add_reservation
puts service.add_reservation
puts service.add_reservation
puts service.add_reservation
puts service.add_reservation
puts service.add_reservation

