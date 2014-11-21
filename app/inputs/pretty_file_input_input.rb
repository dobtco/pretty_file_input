class PrettyFileInputInput < SimpleForm::Inputs::Base
  def input
    @builder.multipart = true
    PrettyFileInput::Component.new(
      name: tag_name,
      persisted: object.persisted?,
      filename: object.try(:send, attribute_name).try(:file).try(:filename)
    ).to_html
  end

  # Not sure why this is so goddamn hard to retrieve
  def tag_name
    ActionView::Helpers::Tags::Base.new(object_name, attribute_name, nil).
      send(:tag_name)
  end
end
