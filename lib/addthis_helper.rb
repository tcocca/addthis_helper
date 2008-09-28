require 'action_view'

module ActionView
  module Helpers
    module AddthisHelper
      def self.included(base)
        base.class_eval do
          include InstanceMethods
        end
      end
      module InstanceMethods
        # Standard AddThis button - no drop down
        # addthis_pub is a required parameter
        # image_src is required
        # image_params is an option hash - values are: 
        #   :width, :height, :border, :alt
        # addthis_optional_params is an optional hash of parameters
        # The only optional params are addthis_url and addthis_title - both are strings
        
        def add_this(addthis_pub, image_src, image_params = {}, addthis_optional_params = {})
          s = "<!-- AddThis Button BEGIN -->"
          s += "<a href=\"http://www.addthis.com/bookmark.php\" onclick=\"addthis_url = " + (addthis_optional_params[:addthis_url].blank? ? "location.href;" : "'#{addthis_optional_params[:addthis_url]}';") + " addthis_title = " + (addthis_optional_params[:addthis_title].blank? ? "document.title;" : "'#{addthis_optional_params[:addthis_title]}';") + " return addthis_click(this);\" target=\"_blank\">"
          s += "<img src=\"#{image_src}\" "
          image_params.each do |key, val|
            s += "#{key.to_s}=\"#{val}\" "
          end unless image_params.nil?
          s += "</a>"
          s += "<script type=\"text/javascript\">"
          s += "var addthis_pub = '#{addthis_pub}';"
          s += "</script>"
          s += "<script type=\"text/javascript\" src=\"http://s9.addthis.com/js/widget.php?v=10\"></script>" 
          s += "<!-- AddThis Button END -->"
        end  
        
        # Custom AddThis button with drop down and extended optional params
        # addthis_pub is a required parameter
        # image_src is required
        # image_params is an option hash - values are: 
        #   :width, :height, :border, :alt
        # addthis_optional_params is an optional hash of parameters - helper converts the hash key to the name of the JS variable
        #  See the following page: http://www.addthis.com/customization.php
        
        def add_this_custom(addthis_pub, image_src, image_params = {}, addthis_optional_params = {})
          s = "<!-- AddThis Button BEGIN -->"
          s += "<script type=\"text/javascript\">"
          s += "addthis_pub  = '#{addthis_pub}';"
          s += "addthis_url = '[URL]';"
          s += "addthis_title = '[TITLE]';"
          addthis_optional_params.each do |key, val|
            s += "#{key.to_s} = " + (val.is_a?(Integer) ? "#{val};" : "'#{val}';")
          end
          s += "</script>"
          s += "<a href=\"http://www.addthis.com/bookmark.php\" onmouseover=\"return addthis_open(this, '', addthis_url, addthis_title)\" onmouseout=\"addthis_close()\" onclick=\"return addthis_sendto()\">"
          s += "<img src=\"#{image_src}\" "
          image_params.each do |key, val|
            s += "#{key.to_s}=\"#{val}\" "
          end unless image_params.nil?
          s += " />"
          s += "</a>"
          s += "<script type=\"text/javascript\" src=\"http://s7.addthis.com/js/152/addthis_widget.js\"></script>"
          s += "<!-- AddThis Button END -->"
        end
      end
    end
  end
end

ActionView::Base.class_eval do
  include ActionView::Helpers::AddthisHelper
end
