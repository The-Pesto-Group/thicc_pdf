require 'test_helper'
require 'action_view/test_case'

class ThiccPdfHelperTest < ActionView::TestCase
  include ThiccPdf::ThiccPdfHelper

  test 'thicc_pdf_stylesheet_link_tag should inline the stylesheets passed in' do
    assert_equal "<style type='text/css'>/* Thicc styles */\n</style>",
                 thicc_pdf_stylesheet_link_tag('../../../fixtures/thicc')
  end

  test 'thicc_pdf_image_tag should return the same as image_tag when passed a full path' do
    assert_equal image_tag("file:///#{Rails.root.join('public', 'images', 'pdf')}"),
                 thicc_pdf_image_tag('pdf')
  end

  if Rails::VERSION::MAJOR == 2
    test 'thicc_pdf_javascript_src_tag should return the same as javascript_src_tag when passed a full path' do
      assert_equal javascript_src_tag("file:///#{Rails.root.join('public', 'javascripts', 'pdf')}", {}),
                   thicc_pdf_javascript_src_tag('pdf')
    end
  end

  test 'thicc_pdf_include_tag should return many thicc_pdf_javascript_src_tags' do
    assert_equal [thicc_pdf_javascript_src_tag('foo'), thicc_pdf_javascript_src_tag('bar')].join("\n"),
                 thicc_pdf_javascript_include_tag('foo', 'bar')
  end
end
