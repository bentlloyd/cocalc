###
History viewer for Tasks notebooks  --- very similar to same file in jupyter/ directory. Refactor!
###

immutable  = require('immutable')

{React, ReactDOM, rclass, rtypes, redux}  = require('../smc-react')
{Icon} = require('../r_misc')

misc         = require('smc-util/misc')

{TaskList} = require('./list')

SHOW_DONE_STYLE =
    fontSize     : '12pt'
    color        : '#666'
    padding      : '5px 15px'
    borderBottom : '1px solid lightgrey'

exports.HistoryViewer = HistoryViewer = rclass
    propTypes :
        syncdb  : rtypes.object.isRequired   # syncdb object corresponding to a jupyter notebook
        version : rtypes.object

    getInitialState: ->
        show_done : false

    render_checkbox: ->
        if @state.show_done
            name = 'check-square-o'
        else
            name = 'square-o'
        <Icon name={name} />

    toggle_show_done: ->
        @setState(show_done : not @state.show_done)

    render_show_done: ->
        <div onClick={@toggle_show_done} style={SHOW_DONE_STYLE}>
            {@render_checkbox()} Show done tasks
        </div>

    render_task_list: (doc) ->
        tasks = immutable.Map()
        v = []
        doc.get().forEach (task, i) =>
            task_id = task.get('task_id')
            tasks = tasks.set(task_id, task)
            if (@state.show_done or not task.get('done')) and not task.get('deleted')
                v.push([task.get('last_edited'), task_id])
            return
        v.sort (a,b) -> -misc.cmp(a[0], b[0])
        visible = immutable.fromJS((x[1] for x in v))

        <TaskList
            path       = {@props.syncdb.get_path()}
            project_id = {@props.syncdb.get_project_id()}
            tasks      = {tasks}
            visible    = {visible}
            read_only  = {true}
            style      = {overflowY:'auto'}
            show_max   = {100}
            />

    render: ->
        doc = @props.syncdb.version(@props.version)
        if not doc?
            elt = <span>Unknown version</span>
        else
            elt = @render_task_list(doc)
        <div style={display: 'flex', flexDirection: 'column', height: '100%', overflowY:'hidden'}>
            {@render_show_done()}
            {elt}
        </div>

exports.tasks_history_viewer_jquery_shim = (syncdb) ->
    elt = $("<div class='smc-vfill'></div>")

    obj =
        element     : elt
        show        : -> elt.show()
        hide        : -> elt.hide()
        remove      : -> ReactDOM.unmountComponentAtNode(elt[0])
        set_version : (version) ->
            ReactDOM.render(<HistoryViewer syncdb={syncdb} version={version} />, elt[0])
        to_str      : (version) -> syncdb.version(version).to_str()

    return obj



