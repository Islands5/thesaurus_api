require 'uri'
require 'json'
require 'nokogiri'
require 'open-uri'

module Thesaurus
  API_ENDPOINT = "http://www.thesaurus.com/browse"
  ALLOW_ACTION = ["verb", "noun", "adverb", "conjunction"]
  class Client

    def initialize(**args)
      args.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    # www.thesaurus.comから検索結果を取得する
    # @param [String] term
    # @param [Hash] args {word_class: an ALLOW_ACTION}
    # @return [json_array] 
    def search term, **args
      encoded_term = URI.encode term
      uri = "#{API_ENDPOINT}/#{encoded_term}"
      uri += "/" + args[:word_class] if args[:word_class].present? && ALLOW_ACTION.include?(args[:word_class])
      res = open(uri, &:read)
      parsed_res = Nokogiri::HTML.parse(res)
      words = parsed_res.css('.relevancy-list span.text')
      ret = []
      puts words.class
      words.each do |word|
        ret << word.children.text
      end
      ret.to_json
    end
  end
end
