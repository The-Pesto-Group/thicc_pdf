class ThiccPdf
  module ThiccPdfHelper
    def self.root_path
      String === Rails.root ? Pathname.new(Rails.root) : Rails.root
    end

    def self.add_extension(filename, extension)
      filename.to_s.split('.').include?(extension) ? filename : "#{filename}.#{extension}"
    end

    def thicc_pdf_stylesheet_link_tag(*sources)
      css_dir = ThiccPdfHelper.root_path.join('public', 'stylesheets')
      css_text = sources.collect do |source|
        source = ThiccPdfHelper.add_extension(source, 'css')
        "<style type='text/css'>#{File.read(css_dir.join(source))}</style>"
      end.join("\n")
      css_text.respond_to?(:html_safe) ? css_text.html_safe : css_text
    end

    def thicc_pdf_image_tag(img, options = {})
      image_tag "file:///#{ThiccPdfHelper.root_path.join('public', 'images', img)}", options
    end

    def thicc_pdf_javascript_src_tag(jsfile, options = {})
      jsfile = ThiccPdfHelper.add_extension(jsfile, 'js')
      type = ::Mime.respond_to?(:[]) ? ::Mime[:js] : ::Mime::JS # ::Mime[:js] cannot be used in Rails 2.3.
      src = "file:///#{ThiccPdfHelper.root_path.join('public', 'javascripts', jsfile)}"
      content_tag('script', '', { 'type' => type, 'src' => path_to_javascript(src) }.merge(options))
    end

    def thicc_pdf_javascript_include_tag(*sources)
      js_text = sources.collect { |source| thicc_pdf_javascript_src_tag(source, {}) }.join("\n")
      js_text.respond_to?(:html_safe) ? js_text.html_safe : js_text
    end
  end
end
