require 'test_helper'
ThiccPdf.config = { :exe_path => ENV['WKHTMLTOPDF_BIN'] || '/usr/local/bin/weasyprint' }
HTML_DOCUMENT = '<html><body>Hello World</body></html>'.freeze

class ThiccPdfTest < ActiveSupport::TestCase
  def setup
    @wp = ThiccPdf.new
  end

  test 'should generate PDF from html document' do
    pdf = @wp.pdf_from_string HTML_DOCUMENT
    assert pdf.start_with?('%PDF-1.4')
    assert pdf.rstrip.end_with?('%%EOF')
    assert pdf.length > 100
  end

  test 'should generate PDF from html document with long lines' do
    document_with_long_line_file = File.new('test/fixtures/document_with_long_line.html', 'r')
    pdf = @wp.pdf_from_string(document_with_long_line_file.read)
    assert pdf.start_with?('%PDF-1.4')
    assert pdf.rstrip.end_with?('%%EOF')
    assert pdf.length > 100
  end

  test 'should generate PDF from html existing HTML file without converting it to string' do
    filepath = File.join(Dir.pwd, 'test/fixtures/document_with_long_line.html')
    pdf = @wp.pdf_from_html_file(filepath)
    assert pdf.start_with?('%PDF-1.4')
    assert pdf.rstrip.end_with?('%%EOF')
    assert pdf.length > 100
  end

  test 'should raise exception when no path to weasyprint' do
    assert_raise RuntimeError do
      ThiccPdf.new ' '
    end
  end

  test 'should raise exception when weasyprint path is wrong' do
    assert_raise RuntimeError do
      ThiccPdf.new '/i/do/not/exist/notweasyprint'
    end
  end

  test 'should raise exception when weasyprint is not executable' do
    begin
      tmp = Tempfile.new('weasyprint')
      fp = tmp.path
      File.chmod 0o000, fp
      assert_raise RuntimeError do
        ThiccPdf.new fp
      end
    ensure
      tmp.delete
    end
  end

  test 'should raise exception when pdf generation fails' do
    begin
      tmp = Tempfile.new('weasyprint')
      fp = tmp.path
      File.chmod 0o777, fp
      wp = ThiccPdf.new fp
      assert_raise RuntimeError do
        wp.pdf_from_string HTML_DOCUMENT
      end
    ensure
      tmp.delete
    end
  end

  test 'should output progress when creating pdfs on compatible hosts' do
    wp = ThiccPdf.new
    output = []
    options = { :progress => proc { |o| output << o } }
    wp.pdf_from_string HTML_DOCUMENT, options
    if RbConfig::CONFIG['target_os'] =~ /mswin|mingw/
      assert_empty output
    else
      assert(output.collect { |l| !l.match(/Loading/).nil? }.include?(true)) # should output something like "Loading pages (1/5)"
    end
  end
end
