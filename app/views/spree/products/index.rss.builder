xml.instruct! :xml, version: "1.0"

xml.rss version: "2.0", "xmlns:g" => "http://base.google.com/ns/1.0" do
  xml.channel do
    xml.title SolidusProductFeed.evaluate(SolidusProductFeed.title, self)
    xml.link SolidusProductFeed.evaluate(SolidusProductFeed.link, self)
    xml.description SolidusProductFeed.evaluate(SolidusProductFeed.description, self)
    xml.language SolidusProductFeed.evaluate(SolidusProductFeed.language, self)

    @feed_products.each do |feed_product|
      xml.item do
        feed_product.schema.each_pair do |tag, value|
          value = value.call(self) if value.respond_to?(:call)
          xml.tag! tag, value
        end
      end
    end
  end
end
