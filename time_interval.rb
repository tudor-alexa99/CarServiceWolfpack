class TimeInterval
  def initialize(starting_time, ending_time)
    #  takes strings as time intervals, in the form of 18:30, 20:20 etc
    @starting = starting_time
    @ending = ending_time
  end

  attr_accessor :starting, :ending

  def get_interval
    puts "This is a time interval"
  end
end
