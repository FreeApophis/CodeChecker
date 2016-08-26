

class FileTypes
  FileTypes = { 
    '.cpp' => :cpp,
    '.h' => :header,
    '.rb' => :ruby,
    '.cs' => :csharp,
    '.xml' => :xml,
    '.vcxproj' => :project,
  }
  
  Directory = :directory
  Unknown = :unknown
  
  def self.TypeFromFilepath(path)
    return Directory if (FileTest.directory?(path))

    FileTypes.each do |suffix, filetype|
      check = Regexp.new("#{Regexp.escape(suffix)}$", Regexp::IGNORECASE)
      return filetype if path =~ check
    end

    Unknown
  end
  
end