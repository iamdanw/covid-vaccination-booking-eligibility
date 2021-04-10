# frozen_string_literal: true

require 'nokogiri'
require 'time'

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

  def updated_at
    @updated_at ||= Time.parse(@doc.css('meta[property="article:modified_time"]').attr('content').value)
  end
end
