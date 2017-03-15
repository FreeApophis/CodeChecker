#!/usr/bin/ruby
# BuildSystem2
# ----------------------

require 'find'

require_relative 'Settings'
require_relative 'FileTypes'
require_relative 'VisualStudioHelper'
require_relative 'Test'
require_relative 'IgnoreIssue'

class CodeChecker
   Struct.new("Statistics", :total_files, :violation_files, :violation_lines)

   attr_reader :statistics, :tests
   
  def initialize (settings)
    @statistics = Struct::Statistics.new(0,0,0)
    @settings = settings
    @vs = VisualStudioHelper.new
    @vs.info_banner
    @ignore = IgnoreIssue.new 'ignore.yml'

    check_settings
    load_skip_list
  end
  
  def check_settings
    @settings.checks.each do |check|
      unless all_tests.include? check
        puts "WARNING: Test '#{check}' unknown and will not be performed"
      end
    end
  end

  def load_skip_list
    @skip = []
    @settings.skip.each do |path|
      if File.exists?(path)
        Find.find(path) do |sub|
          @skip << sub      
        end
      end
    end
  end

  def run
    puts "Ignored Issues: #{@ignore.count}"
    
    @settings.paths.each do |path|
      puts path
      Find.find(path) do |sub|        
        next if @skip.include? sub
        ft = FileTypes::TypeFromFilepath(sub)
        if ft != :directory
          @statistics.total_files += 1
          checker(sub, ft)
        end
      end
    end

    puts "Files found:          #{@statistics.total_files}"
    puts "Number of violations: #{@statistics.violation_lines}"
    puts "            in Files: #{@statistics.violation_files}"
    puts "             ignored: #{@ignore.count}"

    clean_up
  end
  
  def clean_up
    puts "CLEAN UP"
    @ignore.store
  end
  
  def append_result(result, new_result)
    return :failed if result == :failed || new_result == :failed
    return :passed if result == :passed || new_result == :passed
    :none
  end

  def checker(filename, filetype)
    result = :none
    testers(filename, filetype) do |test|
      configure_test test
      run_test test
      result = append_result(result, check_result(test))
      fix_problem test
    end

    if :failed == result
      @statistics.violation_files += 1
    end
  end
  
  def configure_test test
    if @settings.configurations[test.class.symbol]
      test.configure @settings.configurations[test.class.symbol]
    end
  end

  def run_test test
    test.run
  rescue Exception => e
    puts e.message
    puts e.backtrace
    exit 1
  end
  
  def check_result test
    case test.result.status
      when :none
      when :passed
      when :failed
        handle_fails test
      else
        puts test.result.inspect
        exit 1
    end
    return test.result.status
  end
  
  def handle_fails test
    @statistics.violation_lines += test.result.fails.count
  
    test.result.fails.each do |fail|
      next if @ignore.ignored? test.class.symbol, test.result.file, fail.line
      puts fail.message
      if @settings.open_in_visual_studio
        interactive = @vs.starter test.result.file, fail.line
        if (interactive == :quit)
          clean_up
          exit
        end
        if (interactive == :ignore)
        fail.line
          @ignore.add test.class.symbol, test.filename, fail.line
        end
      end
    end
  end
  
  def fix_problem test
    if @settings.try_fix_problems
      if test.fix?
        @vs.checkout test.filename if @settings.tfs_checkout
      
        test.fix
      end
    end
  end
  
end
