require 'thicc_pdf/pdf_helper'
require 'thicc_pdf/thicc_pdf_helper'
require 'thicc_pdf/thicc_pdf_helper/assets'

class ThiccPdf
  if defined?(Rails.env)
    class ThiccRailtie < Rails::Railtie
      initializer 'thicc_pdf.register', after: 'remotipart.controller_helper' do |_app|
        ActiveSupport.on_load(:action_controller) { ActionController::Base.send :prepend, PdfHelper }
        ActiveSupport.on_load(:action_view) { include ThiccPdfHelper::Assets }
      end
    end

    Mime::Type.register('application/pdf', :pdf) if Mime::Type.lookup_by_extension(:pdf).nil?

  end
end
