module LiteratureRequests
  class Person < Entity
    require :first_name, :last_name

    def name
      "#{first_name} #{last_name}"
    end
    alias to_s name

    def <=>(other)
      cmp = last_name <=> other.last_name
      return cmp unless cmp == 0

      first_name <=> first_name
    end

    def group_overseer
      self[:group_overseer] || name
    end

    def admin?
      admin
    end

    def group_overseer?
      overseer
    end
  end
end
