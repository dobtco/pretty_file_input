require 'erector'

class PrettyFileInput::Component < Erector::Widget
  needs :name,                # input name that will be sent to the server
        persisted: false,     # is parent object is not persisted, no AJAX calls will be made
        filename: nil,        # pre-populate the filename span
        method: nil,          # override the parent form's method
        action: nil,          # override the parent form's action
        additional_params: {} # additional parameters to be sent to server with each request

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
        a.button.mini.info t('actions.remove'), 'data-pfi-remove' => true
      }
      div.pfi_not_uploaded {
        input type: 'file'
        span.pfi_status
      }
    }
  end
end
