require_relative 'Test'

class HeaderGuardTest < Test 
  def initialize(filename, filetype)
    super(filename, filetype)

    @check_filetypes << :header
    @check_filetypes << :cpp
  end

  def self.symbol
    :header_guard
  end
  @@skip_makros = ['VC_EXTRALEAN', '_AFX_NO_OLE_SUPPORT', '_AFX_NO_AFXCMN_SUPPORT', '_CONSOLE', '_ELE_FAK', '_NAKA', 'HAVE_ZLIB', 'SHARED_HANDLERS', 'NOUNCRYPT']

  def run_implementation    
    matched = false
    define = nil

    File.foreach(@filename).with_index do |line, index|
      line.strip!
      if matched and (line == "#define #{define}")
        @result.failed "File #{@filename} on line #{index_to_line_number(index)} has a header guard: #{define}", index
      end
      if matched and (line =~ /#include \S*/)
        @result.failed "File #{@filename} on line #{index_to_line_number(index)} has probably an external header guard: #{define}", index
      end
      matched = false
      line.scan(/#ifndef (\S*)/) do |match|
        unless (@@skip_makros.include?(match[0]) || match[0] =~ /[A-Z]*_IMPORT_EXPORT/)
          define = match[0]
          matched = true
        end
      end
    end
    @result.done
  end
end