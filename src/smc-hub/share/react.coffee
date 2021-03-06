###
Load react support for rendering.
###

async = require('async')

# Code for rendering react components to html.
ReactDOMServer = require('react-dom/server')

require('./jsdom-support')
{process_react_component} = require('./process-react')

# Uncomment for cc-in-cc dev benchmarking purposes.  This variable is already set
# by the Docker container when running in kubernetes.
## process.NODE_ENV="production"

exports.react = (res, component, extra, viewer) ->
    res.type('html')
    # we will definitely want to disable mathjax someday for any filetypes that don't need it,
    # since it can be slow, even if nothing gets processed.
    use_mathjax = true
    async.series([
        (cb) ->
            if not use_mathjax
                cb()
                return
            t0 = new Date()
            process_react_component component, viewer, ->
                console.log("react: time to process mathjax: #{new Date() - t0}ms", extra)
                cb()
        (cb) ->
            t0 = new Date()
            stream = ReactDOMServer.renderToStaticNodeStream(component)
            stream.pipe(res)
            stream.once 'end', ->
                console.log("react: time to render and stream out: #{new Date() - t0}ms", extra)
                cb()
    ])
