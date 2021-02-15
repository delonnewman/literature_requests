module LiteratureRequests
  class Group
    include Enumerable

    attr_reader :overseer

    def initialize(members)
      @overseer = members.first(&:group_overseer).group_overseer
      @members  = members
    end

    def each(&block)
      @members.each(&block)
      self
    end
  end
end
