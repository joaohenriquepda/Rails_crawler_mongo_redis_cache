module QuotesHelper
  def fetch_quotes(param)
    quotes = $redis.get(param)
    if quotes.nil?
      quotes = Quote.crawler_data(param)
      $redis.set(param, quotes)
      $redis.expire(param,2.hours.to_i)
    end
    JSON.load quotes
  end

end
