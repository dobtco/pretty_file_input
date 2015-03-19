require 'erector'

class PrettyFileInput::Component < Erector::Widget
  needs :name,
        persisted: false,
        filename: nil,
        method: nil,
        action: nil,
        additional_params: {}

  def content
    div(
      class: 'pfi cf',
      'data-pfi' => {
        name: @name,
        persisted: @persisted,
        action: @action,
        method: @method,
        additionalParams: @additional_params
      }.to_json
    ) {
      div.js_pfi_present(style: @filename ? nil : 'display:none;') {
        span.js_pfi_filename @filename
        text ' '
        a.button.mini.info 'Remove', 'data-pfi-remove' => true
      }
      div.js_pfi_blank(style: @filename ? 'display:none;' : nil) {
        input type: 'file'
        span.js_pfi_status
      }
    }
  end
end
