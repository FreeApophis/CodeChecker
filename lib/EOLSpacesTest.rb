require_relative 'Test'

class EOLSpacesTest < Test
  def initialize(filename, filetype)
    super(filename, filetype)

    @check_filetypes << :header
    @check_filetypes << :cpp
  end
  
  def self.symbol
    :eol_spaces
  end
  
  def remove_eol_spaces(line)
    line.rstrip + "\n"
  end
  
  def run_implementation    
    File.foreach(@filename).with_index do |line, index|
      if line != remove_eol_spaces(line)
        @result.failed "File #{@filename} has spaces at end of line #{index_to_line_number(index)}", index
      end
    end   
    @result.done
  end
  
  def fix_implementation
    puts "FIX SPACES: #{filename}"

    text = File.read(filename)
    new_content = text.lines.map(&:rstrip).map{|l| l + "\n"}.join

    File.open(filename, "w") { |file| file.puts new_content }
  end
end


        

