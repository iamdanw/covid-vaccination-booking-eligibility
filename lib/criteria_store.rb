# frozen_string_literal: true

class CriteriaStore
  attr_reader :criteria

  def initialize(criteria)
    @criteria = criteria
  end

  def latest
    @criteria.max do |a, b|
      a['updated_at'] <=> b['updated_at']
    end
  end

  def add(new_criteria, updated_at)
    @criteria.push(
      {
        'updated_at' => updated_at,
        'criteria' => new_criteria
      }
    )
  end
end
