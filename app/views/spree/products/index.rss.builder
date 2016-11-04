xml.instruct! :xml, version: "1.0"

xml.rss version: "2.0", "xmlns:g" => "http://base.google.com/ns/1.0" do
  xml.channel do
    xml.title current_store.name
    xml.link "http://#{current_store.url}"
    xml.description "Find out about new products on http://#{current_store.url} first!"
    xml.language 'en-us'

    @feed_products.each do |fp|
      fp.item xml
    end
  end
end
