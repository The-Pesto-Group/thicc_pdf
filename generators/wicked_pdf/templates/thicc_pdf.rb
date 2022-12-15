# ThiccPDF Global Configuration
#
# Use this to set up shared configuration options for your entire application.
# Any of the configuration options shown here can also be applied to single
# models by passing arguments to the `render :pdf` call.
#
# To learn more, check out the README:
#
# https://github.com/The-Pesto-Group/thicc_pdf/blob/master/README.md

ThiccPdf.config = {
  # Path to the weasyprint executable: This usually isn't needed if using
  # one of the weasyprint-binary family of gems.
  # exe_path: '/usr/local/bin/weasyprint',
  #   or
  # exe_path: Gem.bin_path('weasyprint-binary', 'weasyprint')

  # Needed for weasyprint 0.12.6+ to use many thicc_pdf asset helpers
  # enable_local_file_access: true,

  # Layout file to be used for all PDFs
  # (but can be overridden in `render :pdf` calls)
  # layout: 'pdf.html',

  # Using weasyprint without an X server can be achieved by enabling the
  # 'use_xvfb' flag. This will wrap all weasyprint commands around the
  # 'xvfb-run' command, in order to simulate an X server.
  #
  # use_xvfb: true,
}
