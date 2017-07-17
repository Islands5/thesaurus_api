class ThesaurusController < ApplicationController
  before_action :set_thesaurus_client, only: [:show]

  def show
    option = {
      default_keywords_limit: 20,
      word_class: params[:word_class]
    }
    res = @client.search params[:term], option
    render json: res
  rescue StandardError => e
    render json: []
  end

  def set_thesaurus_client
    @client = Thesaurus::Client.new
  end
end
