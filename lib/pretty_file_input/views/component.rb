class PrettyFileInput::Views::Component < PrettyFileInput::Views.base_view_class.constantize
  needs :name,
        persisted: false,
        filename: nil,
        method: nil,
        action: nil,
        additional_params: {}

  def content
    div(
      class: "pfi cf #{filename ? 'is_uploaded' : ''}",
      'data-pfi' => {
        name: name,
        persisted: persisted,
        action: action,
        method: method,
        additionalParams: additional_params
      }.to_json
    ) {
      div(class: 'pfi_uploaded') {
        span filename, class: 'pfi_existing_filename'
        text ' '
        a 'Remove', 'data-pfi-remove' => true, class: 'button mini info'
      }
      div(class: 'pfi_not_uploaded') {
        input type: 'file'
        span class: 'pfi_status'
      }
    }
  end
end
