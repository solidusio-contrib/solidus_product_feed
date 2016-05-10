xml.instruct! :xml, version: "1.0"

xml.rss version: "2.0", "xmlns:g" => "http://base.google.com/ns/1.0" do
  xml.channel do
    xml.title current_store.name
    xml.link "http://#{current_store.url}"
    xml.description "Find out about new products on http://#{current_store.url} first!"
    xml.language 'en-us'

    @feed_products.each do |feed_product|
      xml.item do
        xml.link product_url(feed_product.product)
        xml.author current_store.url

        xml.title feed_product.title
        xml.description feed_product.description
        xml.pubDate feed_product.published_at
        xml.guid feed_product.id
        xml.tag! 'g:id', feed_product.id
        xml.tag! 'g:image_link', feed_product.image_link
        xml.tag! 'g:price', feed_product.price
        xml.tag! 'g:condition', feed_product.condition
      end
    end
  end
end
