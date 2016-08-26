require_relative 'Test'

class UsingNameSpaceTest < Test
  def initialize(filename, filetype)
    super(filename, filetype)

    @check_filetypes << :header
  end

  def self.symbol
    :using_namespace
  end
  
  def run_implementation    
    File.foreach(@filename).with_index do |line, index|
      if (line =~ /using namespace/)          
        @result.failed "The header #{@filename} on #{index_to_line_number(index)} has a using namespace clause", index
      end
    end   
    @result.done
  end
end


        

