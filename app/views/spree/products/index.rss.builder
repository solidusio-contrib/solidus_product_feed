xml.instruct! :xml, version: "1.0"

xml.rss version: "2.0", "xmlns:g" => "http://base.google.com/ns/1.0" do
  xml.channel do
    xml.title current_store.name
    xml.link "http://#{current_store.url}"
    xml.description "Find out about new products on http://#{current_store.url} first!"
    xml.language 'en-us'

    @feed_products.each do |feed_product|
      xml.item do
        xml.tag! 'g:id', feed_product.id
        xml.title feed_product.title
        xml.description feed_product.description
        xml.category feed_product.category if feed_product.category
        xml.link product_url(feed_product.product)
        xml.tag! 'g:image_link', feed_product.image_link
        xml.tag! 'g:condition', feed_product.condition
        xml.tag! 'g:price', feed_product.price.money.format(symbol: false, with_currency: true)
        if feed_product.availability_date
          xml.tag!('g:availability_date', feed_product.availability_date)
        end
        xml.tag!('g:shipping_weight', feed_product.shipping_weight)
      end
    end
  end
end
