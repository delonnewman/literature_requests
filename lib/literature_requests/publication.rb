module LiteratureRequests
  class Publication < Entity
    require :code, :name

    def to_s
      name
    end
  end
end
