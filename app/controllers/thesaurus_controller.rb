class ThesaurusController < ApplicationController
  before_action :set_thesaurus_client, only: [:show]

  def show
    res = @client.search params[:term]
    render json: res
  rescue StandardError => e
    render json: []
  end

  def set_thesaurus_client
    @client = Thesaurus::Client.new
  end
end
