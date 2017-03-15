require_relative 'Tools'

class VisualStudioHelper
  attr_reader :version, :common_tools_path
  
  def initialize
    @version = 0
    initialize_common_tools_path
  end
  
  def info_banner
    puts "Visual Studio"
    puts "Version: #{'%.01f' % (@version / 10.0)}"
    puts "   Path: #{installation_path}"
  end

  def ide_path
    nil if version == 0
    File.absolute_path(File.join(common_tools_path, '..', 'IDE'))
  end
  
  def installation_path
    File.absolute_path(File.join(common_tools_path, '..', '..'))
  end

  def devenv
    File.join(ide_path, 'devenv.exe')
  end

  def tf
    File.join(ide_path, 'TF.exe')
  end
  
  def checkout filename
    system "\"#{tf}\" checkout \"#{filename}\""
  end
  
  def starter_path
    'lib/VisualStudioStarter.exe'
  end
  
  def starter file, index
    system "#{starter_path} #{file} #{index_to_line_number(index)}"
    feedback = gets.chomp 
    
    return :quit if feedback == 'q'
    return :ignore if feedback == 'i'
    return :next
  end

private
  def initialize_common_tools_path
    ENV.each do |key, value|
      if key =~ /VS(\d+)COMNTOOLS/
        version = Regexp.last_match(1).to_i
        if (version > @version)
          @version = version
          @common_tools_path = File.absolute_path(value)
        end
      end
    end
  end
end