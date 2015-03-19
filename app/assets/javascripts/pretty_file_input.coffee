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
      @$button = @$el.find('.js_pfi_browse')
      @buttonText = @$button.text()
      @statusText = @$status.text()

      if @options.persisted
        @_calculateRemoveParams()
        @_copyOptionsFromForm()
      else
        @$input.attr('name', @options.name)

      @_bindEvents()

    _calculateRemoveParams: ->
      removeKey = if @options.name.match(/\[/)
        i = @options.name.lastIndexOf('[')
        "#{@options.name.substring(0, i)}[remove_#{@options.name.substring(i + 1, @options.name.length)}"
      else
        "remove_#{@options.name}"

      @removeParams = {}
      @removeParams[removeKey] = true

    _copyOptionsFromForm: ->
      @options.action ||= @$form.attr('action')
      @options.method ||= @$form.find('[name=_method]').val() || @$form.attr('method')

    remove: ->
      @$status.text @statusText

      if @options.persisted
        @_ajaxRemove()
      else
        @$input.val('')

      @_toggleState()

    _toggleState: ->
      $('.js_pfi_toggle').toggle()

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
          @$button.text(
            if percentComplete == 100
              'Finishing...'
            else
              "Uploading (#{percentComplete}%)"
          )
        complete: =>
          $tmpForm.remove()
        success: $.proxy(@_uploadSuccess, @)
        error: $.proxy(@_uploadError, @)

    _createTemporaryForm: ->
      $form = $("""
        <form action='#{@options.action}' method='post' style='display: inline;'>
          <input type='hidden' name='_method' value='#{@options.method}' />
        </form>
      """)

      $oldInput = @$input
      @$input = $oldInput.clone().val('').insertBefore($oldInput)
      @_bindInputChange()
      $oldInput.appendTo($form)

      # We only add the name immediately before uploading because we
      # don't want to send the input value during submission of an
      # outer form.
      $oldInput.attr('name', @options.name)

      $form.insertBefore(@$input)

      $form

    _uploadSuccess: (data) ->
      if data?.additionalParams?
        @options.additionalParams = data.additionalParams

      @_resetButton()
      @_toggleState()

    _resetButton: ->
      @$button.removeClass('disabled')
      @$button.text @buttonText

    _uploadError: (xhr) ->
      @_resetButton()
      @_flashError(
        if (err = xhr.responseJSON?.error)
          "Error: #{err}"
        else
          'Whoops! An error occurred.'
      )

    _flashError: (msg) ->
      @$status.text msg
      @$status.addClass 'is_error'

      setTimeout =>
        @$status.removeClass 'is_error'
        @$status.text @statusText
      , 2500

    _eventToFilename: (e) ->
      if e.target.files?
        e.target.files[0].name
      else if e.target.value
        e.target.value.replace(/^.+\\/, '')

    _onChange: (e) ->
      @$filename.text @_eventToFilename(e)

      if @options.persisted
        @$button.addClass('disabled')
        @$button.text 'Uploading...'
        @_ajaxUpload()
      else
        @_uploadSuccess()

    _bindEvents: ->
      @$el.on 'click', '.js_pfi_remove', $.proxy(@remove, @)
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
