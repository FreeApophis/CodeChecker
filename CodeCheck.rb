#!/usr/bin/ruby1.9.1

require_relative 'lib/CodeChecker'

settings = Settings.new
settings.checks.concat(all_tests)

# settings.checks << :find
settings.configurations[:find] = /[0-9]*/

settings.open_in_visual_studio = false
settings.tfs_checkout = false
settings.try_fix_problems = false

settings.paths << File.join('C:\\', 'Project', 'Basepath')

checker = CodeChecker.new(settings)
checker.run
