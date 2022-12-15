# Rails generator invoked with 'rails generate thicc_pdf'
class ThiccPdfGenerator < Rails::Generators::Base
  source_root(File.expand_path(File.dirname(__FILE__) + '/../../generators/thicc_pdf/templates'))
  def copy_initializer
    copy_file 'thicc_pdf.rb', 'config/initializers/thicc_pdf.rb'
  end
end
