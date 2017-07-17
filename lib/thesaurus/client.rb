require 'uri'
require 'json'
require 'nokogiri'
require 'open-uri'

module Thesaurus
  API_ENDPOINT = "http://www.thesaurus.com/browse"
  class Client
    def initialize(args = {})
      args.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def search term
      encoded_term = URI.encode term
      uri = "#{API_ENDPOINT}/#{encoded_term}"
      res = open(uri, &:read)
      parsed_res = Nokogiri::HTML.parse(res)
      words = parsed_res.css('.relevancy-list span.text')
      ret = []
      words.each do |word|
        ret << word.children.text
      end
      ret.to_json
    end
  end
end
