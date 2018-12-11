class QuotesSerializer
  include FastJsonapi::ObjectSerializer
  attributes :quote, :author, :author_about, :tags
end
