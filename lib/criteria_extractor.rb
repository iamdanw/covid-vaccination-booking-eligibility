# frozen_string_literal: true

require 'nokogiri'

class CriteriaExtractor
  def initialize(page)
    @doc = Nokogiri::HTML(page)
  end

  def criteria
    @criteria ||= begin
      xpath = '//h2[contains(text(), "Who can use this service")]/parent::*/ul/li'
      criteria_list_items = @doc.xpath(xpath)

      criteria_list_items.map(&:text)
    end
  end
end
