#!/usr/bin/env python
#
# gtk2-du -- gtk2 frontend to du.
#
# Author: Krzysztof Luks <m00se@iq.pl>
#
# Copyright (C) 2002 Krzysztof Luks
# Licence: GNU GPL v 2 or later.
#
# Dependency: python-gtk2
#
# This script is based on gtk-du. Gtk-du is copyright (C) David Westlund
# <daw@wlug.westbo.se>
#
# Version 0.1 -- 06-Nov-2002
#  * initial pre-release
#
# Version 0.2 -- 07-Nov-2002
#  * added scrollbar to text view
#  * some layout adjustments
#  * 'du' button replaced with 'execute' stock button
#

import gtk
import sys
import os

#set_locale Gtk;

def destroy(*args):
        """ Callback function that is activated when the program is destoyed """
        window.hide()
        gtk.main_quit()

def du(*args):
        buffer = text.get_buffer()
        buffer.delete(buffer.get_start_iter(), buffer.get_end_iter())

        files = ""
        for i in sys.argv[1:]:
                files = files +"\"" + i + "\" "
        
        parameters = parameters_entry.get_text()
        out = os.popen("du " + parameters + " " + files, "r")
        
        buffer.insert(buffer.get_start_iter(), out.read())

        out.close()
        
window = gtk.Window(gtk.WINDOW_TOPLEVEL)
window.connect("destroy", destroy)
window.set_border_width(15)
window.set_title("gtk2-du")
window.set_default_size(400, 300)

vbox = gtk.VBox(gtk.FALSE, 0)
window.add(vbox)

hbox = gtk.HBox(gtk.FALSE, 0)
vbox.pack_start(hbox, gtk.FALSE, gtk.FALSE, 0)

parameters_label = gtk.Label("Parameters: ")
hbox.pack_start(parameters_label, gtk.FALSE, gtk.FALSE, 0)
parameters_label.show()

parameters_entry = gtk.Entry()
hbox.pack_start(parameters_entry, gtk.TRUE, gtk.TRUE, 10)
parameters_entry.set_text("-chs")

du_button = gtk.Button(stock='gtk-execute')
du_button.connect('clicked', du)
hbox.pack_start(du_button, gtk.TRUE, gtk.TRUE, 0)

scroll_win = gtk.ScrolledWindow()
scroll_win.set_policy(gtk.POLICY_NEVER, gtk.POLICY_AUTOMATIC)
vbox.pack_start(scroll_win, gtk.TRUE, gtk.TRUE, 0)

text = gtk.TextView()
text.set_editable(gtk.FALSE)

scroll_win.add(text)

close_button = gtk.Button(label = "Close")
close_button.connect('clicked', destroy)
vbox.pack_start(close_button, gtk.FALSE, gtk.FALSE, 0)

du()
window.show_all()
gtk.main()
