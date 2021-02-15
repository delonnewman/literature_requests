module LiteratureRequests
  class PredicateString < BasicObject
    def initialize(string)
      @string = string
    end

    def method_missing(method, *args)
      raise NoMethodError, "undefined method `#{method}' for #{inspect}:#{self.class}" unless respond_to?(method)

      s = method.to_s
      if s.end_with?('?')
        s.chop == @string
      else
        @string.send(method, *args)
      end
    end

    def respond_to?(method)
      @string.respond_to?(method) or method.to_s.end_with?('?')
    end

    def to_s
      @string
    end

    def inspect
      @string.inspect
    end
  end
end
