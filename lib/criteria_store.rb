# frozen_string_literal: true

class CriteriaStore
  class DuplicateCriteriaError < StandardError
  end

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
    raise DuplicateCriteriaError if new_criteria.sort == latest['criteria'].sort

    @criteria.push(
      {
        'updated_at' => updated_at,
        'criteria' => new_criteria
      }
    )
  end
end
