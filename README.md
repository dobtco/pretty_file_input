pretty_file_input [![version]](http://rubygems.org/gems/pretty_file_input) [![build]](https://travis-ci.org/dobtco/pretty_file_input)
=======

pretty_file_input is an attempt to standardize the always-problematic file input in our Rails apps.

## Benefits

- Immediate uploads via AJAX for `persisted?` records
- Upload percentage displayed while uploading
- Identical user interface (without AJAX uploads) for non-`persisted?` records
- Use your existing models and controllers, no changes necessary

## Requirements

- [carrierwave](https://github.com/carrierwaveuploader/carrierwave)
- [simple_form](https://github.com/plataformatec/simple_form) (if using the "Automatic" implementation below)
- jQuery
- [jquery.form](https://github.com/malsup/form/)

## Installation

```sh
# Gemfile
gem 'pretty_file_input'

# application.css
*= require pretty_file_input

# application.js
//= require pretty_file_input
```

## Implementation

There are a couple of ways to use this gem:

### Automatic

By taking advantage of the included simple_form input class, you can start using pretty_file_input with as little as one line of code:

```rb
f.input :avatar, as: :pretty_file_input
```

The resulting behavior will depend on whether or not the parent object is already persisted in the database.

**For existing records**, pretty_file_input will upload and remove files immediately, displaying some nice UI feedback along the way:

![gif](https://s3.amazonaws.com/quickcast/3785/60141/quickcast.gif)

**For new records**, pretty_file_input will not perform any AJAX requests. (Carrierwave stores files alongside your database records, so it's impossible to upload a file _before_ its associated record has been created.)

### Manual

If your use case doesn't fit the patterns above, you can use the "Manual" integration with pretty_file_input. `PrettyFileInput::Component` is an Erector widget that can be customized with the following options:

```rb
:name,                # input name that will be sent to the server
persisted: false,     # is parent object is not persisted, no AJAX calls will be made
filename: nil,        # pre-populate the filename span
method: nil,          # override the parent form's method
action: nil,          # override the parent form's action
additional_params: {} # additional parameters to be sent to server with each request
```

## License

[MIT](http://dobtco.mit-license.org/)

[version]: https://img.shields.io/gem/v/pretty_file_input.svg
[build]: http://img.shields.io/travis/dobtco/pretty_file_input.svg
