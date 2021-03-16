# frozen_string_literal: true

class CriteriaStore
  def initialize(criteria)
    @criteria = criteria
  end

  def latest
    @criteria.max do |a, b|
      a['updated_at'] <=> b['updated_at']
    end
  end
end
