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
      class: "pfi cf #{@filename ? 'is_uploaded' : ''}",
      'data-pfi' => {
        name: @name,
        persisted: @persisted,
        action: @action,
        method: @method,
        additionalParams: @additional_params
      }.to_json
    ) {
      div.pfi_uploaded {
        span.pfi_existing_filename @filename
        text ' '
        a.button.mini.info 'Remove', 'data-pfi-remove' => true
      }
      div.pfi_not_uploaded {
        input type: 'file'
        span.pfi_status
      }
    }
  end
end
