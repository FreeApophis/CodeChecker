require 'yaml'

class IgnoreIssue
  def initialize (file)
    @file = file
    load
  end
  
  def add type, file, line
    unless @ignore.has_key? type
      @ignore[type] = {}
    end
    unless @ignore[type].has_key? file
      @ignore[type][file] = {}
    end
    @ignore[type][file][line] = true
  end
  
  def ignored? type, file, line
    if @ignore.has_key? type
      if @ignore[type].has_key? file
        return @ignore[type][file].has_key? line
      end
    end
    false
  end
  
  def count
    return 0 if @ignore.count == 0
    return @ignore.map {|k, v| v }.first.map{|k,v| v.count}.reduce(:+)
  end
  
  def store
    File.open(@file, 'w') {|f| f.write @ignore.to_yaml }
  end
  
  def load
    if File::exist? @file
      @ignore = YAML.load_file(@file)
    else  
      @ignore = {}
    end
  end
end
