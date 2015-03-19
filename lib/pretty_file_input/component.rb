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
      div.js_pfi_toggle.pfi_file_wrapper(style: @filename ? nil : 'display:none;') {
        div.input_group {
          span.js_pfi_filename @filename
          a.button.info.js_pfi_remove 'Remove'
        }
      }
      label.js_pfi_toggle.pfi_file_wrapper(style: @filename ? 'display:none;' : nil) {
        input type: 'file'
        div.input_group {
          span.js_pfi_filename.js_pfi_status 'Choose a file...'
          a.button.info.js_pfi_browse 'Browse'
        }
      }
    }
  end
end
