class Views::Base < Fortitude::Widget
  doctype :html5
  use_instance_variables_for_assigns true
  format_output false
  start_and_end_comments false
  extra_assigns :use
end
