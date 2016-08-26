require_relative 'Test'

class PragmaOnceTest < Test 
  def initialize(filename, filetype)
    super(filename, filetype)
    
    @check_filetypes << :header
  end

  def self.symbol
    :pragma_once
  end

  def run_implementation    
    File.foreach(@filename).with_index do |line, index|
      if line =~ /#pragma once/
        @result.done
        return
      end
    end
    @result.failed "Header #{@filename} has no '#pragma once'", nil
  end
end