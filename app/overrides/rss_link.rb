Deface::Override.new(virtual_path: 'layouts/spree_application',
                     name: 'product_rss_link',
                     original: '86987c7feaaea3181df195ca520571d801bbbaf3',
                     insert_bottom: "[data-hook='inside_head']",
                     partial: 'solidus_product_feed/head')
