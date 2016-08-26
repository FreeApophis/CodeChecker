require_relative 'Test'

class ImportExportTest < Test 
  def initialize(filename, filetype)
    super(filename, filetype)
    @check_filetypes << :header
  end

  def self.symbol
    :import_export
  end

  def run_implementation    
    File.foreach(@filename).with_index do |line, index|
      if line =~ /#define\s*IMPORT_EXPORT\s*__declspec\(dllexport\)/
        @result.failed "IMPORT_EXPORT defined in File #{@filename} on Line #{index_to_line_number(index)}", index
      end
    end
    @result.done

  end
end