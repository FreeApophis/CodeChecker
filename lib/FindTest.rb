require_relative 'Test'

class FindTest < Test
  def initialize(filename, filetype)
    super(filename, filetype)
  end
  
  def self.symbol
    :find
  end
  
  def configure configruation
    @search = configruation
  end
  
  def run?
      @search != nil and @filetype != :unknown
  end
  
  def run_implementation    
    File.foreach(@filename).with_index do |line, index|
      if m = @search.match(line)
        @result.failed "Found '#{m.to_s}' matching #{@search.inspect} in #{@filename} on line #{index_to_line_number(index)}", index
      end
    end
    @result.done
  end
end
