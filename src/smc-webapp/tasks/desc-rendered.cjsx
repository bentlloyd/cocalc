###
Rendered view of the description of a single task
###

{React, rclass, rtypes}  = require('../smc-react')

{Markdown} = require('../r_misc')

{process_hashtags, process_checkboxes, header_part} = require('./desc-rendering')

{path_split} = require('smc-util/misc')

exports.DescriptionRendered = rclass
    propTypes :
        actions           : rtypes.object
        task_id           : rtypes.string
        desc              : rtypes.string
        path              : rtypes.string
        project_id        : rtypes.string
        full_desc         : rtypes.bool
        read_only         : rtypes.bool
        selected_hashtags : rtypes.immutable.Map
        search_terms      : rtypes.immutable.Set

    shouldComponentUpdate: (next) ->
        return @props.desc              != next.desc or \
               @props.full_desc         != next.full_desc or \
               @props.read_only         != next.read_only or \
               @props.selected_hashtags != next.selected_hashtags or \
               @props.search_terms      != next.search_terms

    render_content: ->
        value = @props.desc
        if not value?.trim()
            return <span style={color:'#666'}>Enter a description...</span>
        if not @props.full_desc
            value = header_part(value)
        value = process_hashtags(value, @props.selected_hashtags)
        if @props.actions?
            value = process_checkboxes(value)
        <Markdown
            value      = {value}
            project_id = {@props.project_id}
            file_path  = {path_split(@props.path).head}
            highlight  = {@props.search_terms}
        />

    on_click: (e) ->
        data = e.target?.dataset
        if not data?
            return
        if data.checkbox?
            e.stopPropagation()
            @props.actions.toggle_desc_checkbox(@props.task_id, parseInt(data.index), data.checkbox == 'true')
        else if data.hashtag?
            e.stopPropagation()
            state = ({'undefined':undefined, '1':1, '-1':-1})[data.state]  # do not use eval -- safer
            if state == 1 or state == -1  # for now negation doesn't go through clicking
                new_state = undefined
            else
                new_state = 1
            @props.actions.set_hashtag_state(data.hashtag, new_state)

    render: ->
        <div style={paddingTop:'5px'} onClick={if not @props.read_only and @props.actions? then @on_click}>
            {@render_content()}
        </div>
