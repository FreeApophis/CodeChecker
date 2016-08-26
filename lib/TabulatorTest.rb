require_relative 'Test'

class TabulatorTest < Test
  def initialize(filename, filetype)
    super(filename, filetype)

    @check_filetypes << :header
    @check_filetypes << :cpp
  end
  
  def self.symbol
    :tabulator
  end
  
  def expand_tabs(s, tab_stops = 4)
    s.gsub(/([^\t\n]*)\t/) do
      $1 + " " * (tab_stops - ($1.size % tab_stops))
    end
  end
  
  def run_implementation    
    File.foreach(@filename).with_index do |line, index|
      if (line =~ /\t/)          
        @result.failed "Unallowed character tabulator: #{@filename} on Line #{index_to_line_number(index)}", index
        break
      end
    end   
    @result.done
  end
  
  def fix_implementation
    puts "FIX TABS: #{@filename}"

    text = File.read(@filename)
    new_content = expand_tabs(text)

    File.open(@filename, "w") { |file| file.puts new_content }
  end
end


        

