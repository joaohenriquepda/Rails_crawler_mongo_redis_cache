# frozen_string_literal: true

# Class QuotesController]
class QuotesController < ApplicationController
  before_action :set_quote, only: [:show, :update, :destroy]

  # GET /quotes
  def index
      @quotes = Quote.all
      render json:  QuotesSerializer.new(@quotes).serialized_json
  end

  # GET /quotes/1
  def show
    render json: @quote
  end

  # POST /quotes
  def create
    @quote = Quote.new(quote_params)

    if @quote.save
      render json: @quote, status: :created, location: @quote
    else
      render json: @quote.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /quotes/1
  def update
    if @quote.update(quote_params)
      render json: @quote
    else
      render json: @quote.errors, status: :unprocessable_entity
    end
  end

  # DELETE /quotes/1
  def destroy
    @quote.destroy
  end

  # POST /quotes/:tag
  def search_quotes_by_tag
    quotes = $redis.get(params[:tag])
    if quotes.nil?
      quotes = Quote.crawler_data(params[:tag])
      puts quotes
      $redis.set(params[:tag], quotes)
      $redis.expire(params[:tag],2.hours.to_i)
    end
    render json: quotes
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_quote
    @quote = Quote.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def quote_params
    params.require(:quote).permit(:quote, :author, :author_about)
  end
end
