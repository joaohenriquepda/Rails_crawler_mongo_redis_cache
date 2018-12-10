# frozen_string_literal: true

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'mechanize'

# Class CrawlerQuotesController
class CrawlerQuotesController < ApplicationController
  def crawler_data
    tag = params[:tag]

    url = 'http://quotes.toscrape.com'
    page = Mechanize.new.get(url + '/tag/' + tag)

    open('myfile.html', 'wb') do |f|
      f.puts page.body
    end

    archive = Nokogiri::HTML(open('myfile.html'))
    file = []
    data = []
    archive.css('body').each do |f|
      f.search('.quote').each do |q|
        tags = []
        q.search('.tag').each do |t|
          tags.push(t.text)
        end

        value = {
          'text': q.search('.text').text,
          'author': q.search('.author').text,
          'author_about': url + q.at('a').attribute('href'),
          'tags': tags
        }

        data.push(value)
      end
      file.push(f.search('.quote'))
    end
    quotes = { 'quotes': data }
    render json: quotes
  end
end
