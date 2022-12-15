class ThiccPdfGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.file 'thicc_pdf.rb', 'config/initializers/thicc_pdf.rb'
    end
  end
end
