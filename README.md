# ThiccPDF

ThiccPDF is a fork of [Wicked PDF](https://github.com/mileszs/wicked_pdf).
It uses WeasyPrint instead of wkhtmltopdf.

WickedPDF supports CSS Flexbox. It does not support Javascript.

### Installation

#### ThiccPDF
Add this to your Gemfile and run `bundle install`:

```ruby
gem 'thicc_pdf'
```

Then create the initializer with

```
rails generate thicc_pdf
```

You may also need to add
```ruby
Mime::Type.register "application/pdf", :pdf
```
to `config/initializers/mime_types.rb` in older versions of Rails.

#### WeasyPrint
`thicc_pdf` wraps [WeasyPrint](https://weasyprint.org/), a Python library that renders HTML to PDFs.

It must be installed separately.

For more information about WeasyPrint, see the project's [documentation](https://doc.courtbouillon.org/weasyprint/stable/).

### Basic Usage
```ruby
class ThingsController < ApplicationController
  def show
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "file_name"   # Excluding ".pdf" extension.
      end
    end
  end
end
```
### Usage Conditions - Important!

WeasyPrint is run outside of your Rails application; therefore, your normal layouts will not work.
If you plan to use any CSS or image files, you must modify your layout so that you provide an absolute reference to these files.
The best option for Rails without the asset pipeline is to use the following helpers:
- `thicc_pdf_stylesheet_link_tag`
- `thicc_pdf_image_tag`

WeasyPrint does not support Javascript.

#### thicc_pdf helpers
```html
<!doctype html>
<html>
  <head>
    <meta charset='utf-8' />
    <%= thicc_pdf_stylesheet_link_tag "pdf" -%>
  </head>
  <body onload='number_pages'>
    <div id="header">
      <%= thicc_pdf_image_tag 'mysite.jpg' %>
    </div>
    <div id="content">
      <%= yield %>
    </div>
  </body>
</html>
```
Using thicc_pdf_helpers with asset pipeline raises `Asset names passed to helpers should not include the "/assets/" prefix.` error. To work around this, you can use `thicc_pdf_asset_base64` with the normal Rails helpers, but be aware that this will base64 encode your content and inline it in the page. This is very quick for small assets, but large ones can take a long time.

```html
<!doctype html>
<html>
  <head>
    <meta charset='utf-8' />
    <%= stylesheet_link_tag thicc_pdf_asset_base64("pdf") %>

  </head>
  <body onload='number_pages'>
    <div id="header">
      <%= image_tag thicc_pdf_asset_base64('mysite.jpg') %>
    </div>
    <div id="content">
      <%= yield %>
    </div>
  </body>
</html>
```

#### Webpacker usage

thicc_pdf supports webpack assets.

- Use `thicc_pdf_stylesheet_pack_tag` for stylesheets
- Use `thicc_pdf_asset_pack_path` to access an asset directly, for example: `image_tag thicc_pdf_asset_pack_path("media/images/foobar.png")`

#### Asset pipeline usage

It is best to precompile assets used in PDF views. This will help avoid issues when it comes to deploying, as Rails serves asset files differently between development and production (`config.assets.compile = false`), which can make it look like your PDFs work in development, but fail to load assets in production.

    config.assets.precompile += ['blueprint/screen.css', 'pdf.css', 'jquery.ui.datepicker.js', 'pdf.js', ...etc...]

### Advanced Usage

_NOTE: Many options from WickedPDF rely on wkhtmltopdf and will not work with ThiccPDF._

```ruby
class ThingsController < ApplicationController
  def show
    respond_to do |format|
      format.html
      format.pdf do
        render pdf:         'file_name',
               disposition: 'attachment',  # default 'inline'
               template:    'things/show',
               locals:      {foo: @bar},
               file:        "#{Rails.root}/files/foo.erb",
               inline:      '<!doctype html><html><head></head><body>INLINE HTML</body></html>',
               layout:      'pdf',         # for a pdf.pdf.erb file
               progress: proc { |output| puts output }  # proc called when console output changes
      end
    end
  end
end
```
By default, it will render without a layout (layout: false) and the template for the current controller and action.

### Configuration

Default configuration is set in `initializers/thicc_pdf.rb`.

### Rack Middleware

If you would like to have ThiccPdf automatically generate PDF views for all (or nearly all) pages by appending .pdf to the URL, add the following to your Rails app:
```ruby
# in application.rb (Rails3) or environment.rb (Rails2)
require 'thicc_pdf'
config.middleware.use ThiccPdf::Middleware
```
If you want to turn on or off the middleware for certain URLs, use the `:only` or `:except` conditions like so:
```ruby
# conditions can be plain strings or regular expressions, and you can supply only one or an array
config.middleware.use ThiccPdf::Middleware, {}, only: '/invoice'
config.middleware.use ThiccPdf::Middleware, {}, except: [ %r[^/admin], '/secret', %r[^/people/\d] ]
```
If you use the standard `render pdf: 'some_pdf'` in your app, you will want to exclude those actions from the middleware.

### Include in an email as an attachment

To include a rendered pdf file in an email you can do the following:

```ruby
attachments['attachment.pdf'] = ThiccPdf.new.pdf_from_string(
  render_to_string('link_to_view.pdf.erb', layout: 'pdf')
)
```

This will render the pdf to a string and include it in the email. This is very slow so make sure you schedule your email delivery in a job.

