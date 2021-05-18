# frozen_string_literal: true

require 'json'
require 'open-uri'

require('./lib/criteria_store')
require('./lib/criteria_extractor')

class CriteriaUpdater
  def initialize(args)
    @file_path = args[0]
    criteria_hash = load_criteria(@file_path)

    @criteria_store = CriteriaStore.new(criteria_hash)
  end

  def run
    extracted_criteria = fetch_latest_criteria

    @criteria_store.add(
      extracted_criteria.criteria,
      extracted_criteria.updated_at.iso8601
    )

    save_criteria(@criteria_store.criteria, @file_path)
  end

  private

  def fetch_latest_criteria
    url = 'https://www.nhs.uk/conditions/coronavirus-covid-19/coronavirus-vaccination/book-coronavirus-vaccination/'
    page = URI.parse(url).open.read
    CriteriaExtractor.new(page)
  end

  def load_criteria(file_path)
    file = File.read(file_path)
    JSON.parse(file)
  end

  def save_criteria(criteria, file_path)
    json_out = JSON.pretty_generate(criteria)
    File.write(file_path, json_out)
  end
end

# Use Ruby constants to make the file runnable from the command line
CriteriaUpdater.new(ARGV).run if $PROGRAM_NAME == __FILE__
