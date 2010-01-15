module DryPluginTestHelper
  class Version
    attr_accessor :major, :minor, :build
    
    def initialize(version_string)
      @major, @minor, @build = *(version_string.split('.'))
    end
    
    def to_s
      version_array.join('.')
    end
    
    def version_array
      [@major, @minor, @build]
    end
    
    def <(other)
      version_array.each_with_index do |part, i|
        return true if part < other.version_array[i]
        return false if other.version_array[i] < part
      end
      false
    end
  end
end
