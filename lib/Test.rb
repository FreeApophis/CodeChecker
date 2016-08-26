require_relative 'TestResult'

class Test
  attr_reader :result, :filename

  def initialize(filename, filetype)
    @filename = filename
    @result = TestResult.new(filename)
    @filetype = filetype
    @check_filetypes = []
  end

  def run?
    @check_filetypes.include?(@filetype)
  end

  def run
    if run?
      run_implementation
    end
  end
  
  def fix?
    @result.status == :failed
  end
  
  def fix
    if fix? and respond_to? :fix_implementation      
      fix_implementation
    end
  end
end

d = File.expand_path(File.dirname(__FILE__))
$test_classes = Dir.glob(File.join(d, "*Test.rb"))
$test_classes = $test_classes.map{|t| File.basename(t, ".rb")}.select{|t| t != "Test"}

$test_classes.each do |test|
  require_relative test
end

def all_tests
  $test_classes.map{ |t| Kernel.const_get(t).symbol }
end

def testers(filename, filetype) 
  $test_classes.each do |test|
    type = Kernel.const_get(test)
    if @settings.checks.include?(type::symbol)
      yield type.new(filename, filetype)
    end
  end
end


