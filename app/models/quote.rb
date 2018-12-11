class Quote
  include Mongoid::Document
  field :text, type: String
  field :author, type: String
  field :author_about, type: String
  field :tags, type: Array, default: []


  def self.crawler_data(tag)
    url = 'http://quotes.toscrape.com'
    page = Mechanize.new.get(url + '/tag/' + tag)

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
        Quote.create(
          'text': q.search('.text').text,
          'author': q.search('.author').text,
          'author_about': url + q.at('a').attribute('href'),
          'tags': tags
        )
        data.push(value)
      end
    end
    quotes = { 'quotes': data }
  end
end
