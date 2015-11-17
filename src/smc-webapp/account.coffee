###############################################################################
#
# SageMathCloud: A collaborative web-based interface to Sage, IPython, LaTeX and the Terminal.
#
#    Copyright (C) 2014, William Stein
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
###############################################################################


############################################################
# Account Settings
############################################################

{top_navbar}    = require('./top_navbar')
{salvus_client} = require('./salvus_client')
{alert_message} = require('./alerts')
account_page    = require('./account_page')

misc     = require("misc")
{flux}   = require('./r')

################################################
# id of account client browser thinks it is signed in as
################################################
top_navbar.on "switch_to_page-account", () ->
    if flux.getStore('account').is_logged_in()
        window.history.pushState("", "", window.smc_base_url + '/settings/account')
    else
        window.history.pushState("", "", window.smc_base_url + '/')

account_page.mount()

################################################
# Account creation
################################################

first_login = true
hub = undefined

# load more of the app now that user is logged in.
load_app = (cb) ->
    require.ensure [], ->
        require('./r_account.cjsx')  # initialize react-related account page
        require('./projects.cjsx')   # initialize project listing
        require('./file_use.cjsx')   # initialize file_use notifications
        cb()

signed_in = (mesg) ->
    ga('send', 'event', 'account', 'signed_in')    # custom google analytic event -- user signed in
    # Record which hub we're connected to.
    hub = mesg.hub

    top_navbar.show_page_button("projects")
    load_file = window.salvus_target and window.salvus_target != 'login'
    if first_login
        first_login = false
        if not load_file
            load_app ->
                require('./history').load_target('projects')

    if load_file
        # wait until account settings get loaded, then show target page
        # TODO: This is hackish!, and will all go away with a more global use of React (and routing).
        # The underscore below should make it clear that this is hackish.
        flux.getTable('account')._table.once 'change', ->
            load_app ->
                require('./history').load_target(window.salvus_target)
                window.salvus_target = ''


# Listen for pushed sign_in events from the server.  This is one way that
# the sign_in function above can be activated, but not the only way.
salvus_client.on("signed_in", signed_in)

################################################
# Version number check
################################################
salvus_client.on 'new_version', ->
    $(".salvus_client_version_warning").show()

$(".salvus_client_version_warning").draggable().css('position','fixed').find(".fa-times").click () ->
    $(".salvus_client_version_warning").hide()

# Connection information dialog

$(".salvus-connection-status").click () ->
    show_connection_information()
    return false

$("a[href=#salvus-connection-reconnect]").click () ->
    salvus_client._fix_connection()
    return false

show_connection_information = () ->
    dialog = $(".salvus-connection-info")
    dialog.modal('show')
    if hub?
        dialog.find(".salvus-connection-hub").show().find('pre').text(hub)
        dialog.find(".salvus-connection-nohub").hide()
    else
        dialog.find(".salvus-connection-nohub").show()
        dialog.find(".salvus-connection-hub").hide()
    s = require('./salvus_client')

    if s.ping_time()
        dialog.find(".salvus-connection-ping").show().find('pre').text("#{s.ping_time()}ms")
    else
        dialog.find(".salvus-connection-ping").hide()



################################################
# Automatically log in
################################################
if localStorage.remember_me or window.location.hash.substr(1) == 'login'
    $(".salvus-remember_me-message").show()
    $(".salvus-sign_in-form").hide()
    # just in case, always show manual login screen after 45s.
    setTimeout((()=>$(".salvus-remember_me-message").hide(); $(".salvus-sign_in-form").show()), 45000)

salvus_client.on "remember_me_failed", () ->
    $(".salvus-remember_me-message").hide()
    $(".salvus-sign_in-form").show()
    if current_account_page == 'account-settings'  # user was logged in but now isn't due to cookie failure
        f = ->
            if not localStorage.remember_me?
                #show_page("account-landing")
                alert_message(type:"info", message:"You might have to sign in again.", timeout:1000000)
        setTimeout(f, 15000)  # give it time to possibly resolve itself.  TODO: confused about what is going on here...

# Return a default filename with the given ext (or not extension if ext not given)
# TODO: make this configurable with different schemas.
exports.default_filename = (ext, is_folder) ->
    return default_filename_iso(ext)
    #return default_filename_mac(ext)

default_filename_iso = (ext, is_folder) ->
    base = misc.to_iso(new Date()).replace('T','-').replace(/:/g,'')
    if ext
        base += '.' + ext
    return base

# This isn't used yet -- will not a config option in account settings.
default_filename_mac = (ext, is_folder) ->
    switch ext
        when 'zip'
            return 'Archive.zip'
        else
            return 'untitled ' + (if is_folder then 'folder' else 'file')
