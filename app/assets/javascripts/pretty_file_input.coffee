(($, window) ->

  class PrettyFileInput
    defaults:
      additionalParams: {}
      name: undefined
      persisted: undefined
      action: undefined
      method: undefined

    constructor: ($el, options) ->
      @$el = $el
      @options = $.extend {}, @defaults, options, @$el.data('pfi')

      @$form = @$el.closest('form')
      @$input = @$el.find('input')
      @$filename = @$el.find('.js_pfi_filename')
      @$status = @$el.find('.js_pfi_status')

      # If we're not persisted, immediately add the correct input name
      if !@options.persisted
        @$input.attr('name', @options.name)

      removeKey = if @options.name.match(/\[/)
        i = @options.name.lastIndexOf('[')
        "#{@options.name.substring(0, i)}[remove_#{@options.name.substring(i + 1, @options.name.length)}"
      else
        "remove_#{@options.name}"

      @removeParams = {}
      @removeParams[removeKey] = true

      @options.action ||= @$form.attr('action')
      @options.method ||= @$form.find('[name=_method]').val() || @$form.attr('method')

      @_bindEvents()

    remove: ->
      if @options.persisted
        @_ajaxRemove()
      else
        @$input.val('')

      @_toggleState()

    _toggleState: ->
      $('.js_pfi_present, .js_pfi_blank').toggle()

    _baseParams: ->
      $.extend { pretty_file_input: true }, @options.additionalParams

    _ajaxRemove: ->
      $.ajax
        url: @options.action
        type: @options.method
        dataType: 'json'
        data: $.extend @_baseParams(), @removeParams

    _ajaxUpload: ->
      $tmpForm = @_createTemporaryForm()

      $tmpForm.ajaxSubmit
        dataType: 'json'
        data: @_baseParams()
        uploadProgress: (_, __, ___, percentComplete) =>
          @$status.text(
            if percentComplete == 100
              'Finishing'
            else
              "Uploading (#{percentComplete}%)"
          )
        complete: =>
          @$input.show()
          $tmpForm.remove()
        success: $.proxy(@_uploadSuccess, @)
        error: $.proxy(@_uploadError, @)

    _createTemporaryForm: ->
      form = $("""
        <form action='#{@options.action}' method='post' style='display: inline;'>
          <input type='hidden' name='_method' value='#{@options.method}' />
        </form>
      """)

      $oldInput = @$input
      @$input = $oldInput.clone().hide().val('').insertBefore($oldInput)
      @_bindInputChange()
      $oldInput.appendTo(form)

      # We only add the name immediately before uploading because we
      # don't want to send the input value during submission of an
      # outer form.
      $oldInput.attr('name', @options.name)

      form.insertBefore(@$input)

      form

    _uploadSuccess: (data) ->
      if data?.additionalParams?
        @options.additionalParams = data.additionalParams

      @$status.text('')
      @_toggleState()

    _uploadError: (xhr) ->
      msg = if (err = xhr.responseJSON?.error)
              "Error: #{err}"
            else
              'Whoops! An error occurred.'

      @$status.text msg
      setTimeout ( => @$status.text('') ), 2000

    _eventToFilename: (e) ->
      if e.target.files?
        e.target.files[0].name
      else if e.target.value
        e.target.value.replace(/^.+\\/, '')

    _onChange: (e) ->
      @$filename.text @_eventToFilename(e)

      if @options.persisted
        @$status.text 'Uploading...'
        @_ajaxUpload()
      else
        @_uploadSuccess()

    _bindEvents: ->
      @$el.on 'click', '[data-pfi-remove]', $.proxy(@remove, @)
      @_bindInputChange()

    # FF6 doesn't bubble the 'change' event, so we need to bind
    # directly to the @$input. Since we need to re-bind later,
    # we break this out into a separate method.
    _bindInputChange: ->
      @$input.on 'change', $.proxy(@_onChange, @)

  $.fn.extend prettyFileInput: (option, args...) ->
    @each ->
      data = $(@).data('pretty-file-input')

      if !data
        $(@).data 'pretty-file-input', (data = new PrettyFileInput($(@), option))
      if typeof option == 'string'
        data[option].apply(data, args)

) window.jQuery, window

$ ->
  $('[data-pfi]').prettyFileInput()
