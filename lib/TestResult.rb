class TestResult
  attr_reader :file, :fails
  
  Struct.new("TestFailed", :message, :line)
  
  def initialize file
    @done = false
    @file = file
    @fails = []
  end
  
  def status
    if @fails.any?
      :failed
    else 
      if @done
        :passed
      else 
        :none
      end
    end
  end 
  
  def failed message, line = nil
    failed = Struct::TestFailed.new message, line
    @fails << failed
    return self
  end
  
  def done
    @done = true
    return self
  end
end