require 'test_helper'
require 'action_view/test_case'

class ThiccPdfHelperAssetsTest < ActionView::TestCase
  include ThiccPdf::ThiccPdfHelper::Assets

  if Rails::VERSION::MAJOR > 3 || (Rails::VERSION::MAJOR == 3 && Rails::VERSION::MINOR > 0)
    test 'thicc_pdf_asset_base64 returns a base64 encoded asset' do
      assert_match %r{data:text\/css;base64,.+}, thicc_pdf_asset_base64('thicc.css')
    end

    test 'thicc_pdf_stylesheet_link_tag should inline the stylesheets passed in' do
      Rails.configuration.assets.expects(:compile => true)
      assert_equal "<style type='text/css'>/* Thicc styles */\n\n</style>",
                   thicc_pdf_stylesheet_link_tag('thicc')
    end

    test 'thicc_pdf_image_tag should return the same as image_tag when passed a full path' do
      Rails.configuration.assets.expects(:compile => true)
      assert_equal image_tag("file:///#{Rails.root.join('public', 'pdf')}"),
                   thicc_pdf_image_tag('pdf')
    end

    test 'thicc_pdf_javascript_include_tag should inline the javascripts passed in' do
      Rails.configuration.assets.expects(:compile => true)
      assert_equal "<script type='text/javascript'>// Thicc js\n;\n</script>",
                   thicc_pdf_javascript_include_tag('thicc')
    end

    test 'thicc_pdf_asset_path should return a url when assets are served by an asset server' do
      expects(:asset_pathname => 'http://assets.domain.com/dummy.png')
      assert_equal 'http://assets.domain.com/dummy.png', thicc_pdf_asset_path('dummy.png')
    end

    test 'thicc_pdf_asset_path should return a url when assets are served by an asset server using HTTPS' do
      Rails.configuration.assets.expects(:compile => false)
      expects(:asset_path => 'https://assets.domain.com/dummy.png')
      assert_equal 'https://assets.domain.com/dummy.png', thicc_pdf_asset_path('dummy.png')
    end

    test 'thicc_pdf_asset_path should return a url with a protocol when assets are served by an asset server with relative urls' do
      Rails.configuration.assets.expects(:compile => false)
      expects(:asset_path => '//assets.domain.com/dummy.png')
      assert_equal 'http://assets.domain.com/dummy.png', thicc_pdf_asset_path('dummy.png')
    end

    test 'thicc_pdf_asset_path should return a url with a protocol when assets are served by an asset server with no protocol set' do
      Rails.configuration.assets.expects(:compile => false)
      expects(:asset_path => 'assets.domain.com/dummy.png')
      assert_equal 'http://assets.domain.com/dummy.png', thicc_pdf_asset_path('dummy.png')
    end

    test 'thicc_pdf_asset_path should return a path' do
      Rails.configuration.assets.expects(:compile => true)
      path = thicc_pdf_asset_path('application.css')

      assert path.include?('/app/assets/stylesheets/application.css')
      assert path.include?('file:///')

      Rails.configuration.assets.expects(:compile => false)
      expects(:asset_path => '/assets/application-6fba03f13d6ff1553477dba03475c4b9b02542e9fb8913bd63c258f4de5b48d9.css')
      path = thicc_pdf_asset_path('application.css')

      assert path.include?('/public/assets/application-6fba03f13d6ff1553477dba03475c4b9b02542e9fb8913bd63c258f4de5b48d9.css')
      assert path.include?('file:///')
    end

    # This assets does not exists so probably it doesn't matter what is
    # returned, but lets ensure that returned value is the same when assets
    # are precompiled and when they are not
    test 'thicc_pdf_asset_path should return a path when asset does not exist' do
      Rails.configuration.assets.expects(:compile => true)
      path = thicc_pdf_asset_path('missing.png')

      assert path.include?('/public/missing.png')
      assert path.include?('file:///')

      Rails.configuration.assets.expects(:compile => false)
      expects(:asset_path => '/missing.png')
      path = thicc_pdf_asset_path('missing.png')

      assert path.include?('/public/missing.png')
      assert path.include?('file:///')
    end

    test 'thicc_pdf_asset_path should return a url when asset is url' do
      Rails.configuration.assets.expects(:compile => true)
      expects(:asset_path => 'http://example.com/rails.png')
      assert_equal 'http://example.com/rails.png', thicc_pdf_asset_path('http://example.com/rails.png')

      Rails.configuration.assets.expects(:compile => false)
      expects(:asset_path => 'http://example.com/rails.png')
      assert_equal 'http://example.com/rails.png', thicc_pdf_asset_path('http://example.com/rails.png')
    end

    test 'thicc_pdf_asset_path should return a url when asset is url without protocol' do
      Rails.configuration.assets.expects(:compile => true)
      expects(:asset_path => '//example.com/rails.png')
      assert_equal 'http://example.com/rails.png', thicc_pdf_asset_path('//example.com/rails.png')

      Rails.configuration.assets.expects(:compile => false)
      expects(:asset_path => '//example.com/rails.png')
      assert_equal 'http://example.com/rails.png', thicc_pdf_asset_path('//example.com/rails.png')
    end

    test 'ThiccPdfHelper::Assets::ASSET_URL_REGEX should match various URL data type formats' do
      assert_match ThiccPdf::ThiccPdfHelper::Assets::ASSET_URL_REGEX, 'url(\'/asset/stylesheets/application.css\');'
      assert_match ThiccPdf::ThiccPdfHelper::Assets::ASSET_URL_REGEX, 'url("/asset/stylesheets/application.css");'
      assert_match ThiccPdf::ThiccPdfHelper::Assets::ASSET_URL_REGEX, 'url(/asset/stylesheets/application.css);'
      assert_match ThiccPdf::ThiccPdfHelper::Assets::ASSET_URL_REGEX, 'url(\'http://assets.domain.com/dummy.png\');'
      assert_match ThiccPdf::ThiccPdfHelper::Assets::ASSET_URL_REGEX, 'url("http://assets.domain.com/dummy.png");'
      assert_match ThiccPdf::ThiccPdfHelper::Assets::ASSET_URL_REGEX, 'url(http://assets.domain.com/dummy.png);'
      assert_no_match ThiccPdf::ThiccPdfHelper::Assets::ASSET_URL_REGEX, '.url { \'http://assets.domain.com/dummy.png\' }'
    end

    test 'prepend_protocol should properly set the protocol when the asset is precompiled' do
      assert_equal 'http://assets.domain.com/dummy.png', prepend_protocol('//assets.domain.com/dummy.png')
      assert_equal '/assets.domain.com/dummy.png', prepend_protocol('/assets.domain.com/dummy.png')
      assert_equal 'http://assets.domain.com/dummy.png', prepend_protocol('http://assets.domain.com/dummy.png')
      assert_equal 'https://assets.domain.com/dummy.png', prepend_protocol('https://assets.domain.com/dummy.png')
    end
  end
end
