require_relative 'Test'

class TodoTest < Test
  def initialize(filename, filetype)
    super(filename, filetype)
    @check_filetypes << :header
    @check_filetypes << :cpp
    @check_filetypes << :java
    @check_filetypes << :ruby
    @check_filetypes << :php
  end
  
  def self.symbol
    :todo
  end
  
  def trim str
    str.strip!   
    str = str[2..-1] if str.start_with?("//")
    
    return str.strip
  end
  
  def run_implementation    
    File.foreach(@filename).with_index do |line, index|
      if (line =~ /todo/i)
        @result.failed "TODO: #{@filename} on line #{index_to_line_number(index)}: (#{trim(line)})", index
      end
    end   
    @result.done
  end
end
