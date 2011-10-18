Deface::Override.new(:virtual_path => 'layouts/spree_application',
                     :name => 'product_rss_link',
                     :insert_bottom => "[data-hook='inside_head']",
                     :text => '<%= auto_discovery_link_tag(:rss, products_path(:format => :rss), {:title => "#{Spree::Config[:site_title]} Products"}) %>')
