require 'uri'
require 'json'
require 'nokogiri'
require 'open-uri'

module Thesaurus
  API_ENDPOINT = "http://www.thesaurus.com/browse"
  ALLOW_ACTION = ["verb", "noun", "adverb", "conjunction"]
  class Client

    def initialize(args = {default_keywords_limit: 20, word_class: "verb"})
      args.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    # www.thesaurus.comから検索結果を取得する
    # @param [Integer] default_keywords_limit
    # @param [enum] word_class 
    # @return [json_array] 
    def search term, args={default_keywords_limit: 20}
      encoded_term = URI.encode term
      uri = "#{API_ENDPOINT}/#{encoded_term}"
      uri += "/" + args[:word_class] if args[:word_class].present? && ALLOW_ACTION.include?(args[:word_class])
      res = open(uri, &:read)
      parsed_res = Nokogiri::HTML.parse(res)
      words = parsed_res.css('.relevancy-list span.text')
      ret = []
      words.each.with_index(1) do |word, i|
        break if i > args[:default_keywords_limit]
        ret << word.children.text
      end
      ret.to_json
    end
  end
end
