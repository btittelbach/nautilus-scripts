#!/bin/sh
dbus-send --session --type=method_call --dest=org.guake.RemoteControl /org/guake/RemoteControl org.guake.RemoteControl.show_hide
dbus-send --session --type=method_call --dest=org.guake.RemoteControl /org/guake/RemoteControl org.guake.RemoteControl.execute_command string:"ccd '$*'"
