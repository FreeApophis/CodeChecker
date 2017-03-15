class Settings
  attr_reader :paths, :checks, :configurations, :skip
  attr_accessor :try_fix_problems, :open_in_visual_studio, :tfs_checkout

  def initialize
    @try_fix_problems = false
    @open_in_visual_studio = false
    @tfs_checkout = false
    @paths = []
    @checks = []
    @configurations = {}
    @skip = []
  end
end
