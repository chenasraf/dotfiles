# Dropzone Action Info
# Name: Fix Screenshot Names
# Description: Describes what your action will do.
# Handles: Files
# Creator: Chen Asraf
# URL: https://casraf.blog
# Events: Clicked, Dragged
# KeyModifiers: Command, Option, Control, Shift
# SkipConfig: No
# RunsSandboxed: Yes
# Version: 1.0
# MinDropzoneVersion: 3.5

import time
import os
import re

def dragged():
    # Welcome to the Dropzone 4 API! It helps to know a little Python before playing in here.
    # If you haven't coded in Python before, there's an excellent introduction at http://www.codecademy.com/en/tracks/python

    # Each meta option at the top of this file is described in detail in the Dropzone API docs at https://github.com/aptonic/dropzone3-actions/blob/master/README.md#dropzone-3-api
    # You can edit these meta options as required to fit your action.
    # You can force a reload of the meta data by clicking the Dropzone status item and pressing Cmd+R

    # This is a Python method that gets called when a user drags items onto your action.
    # You can access the received items using the items global variable e.g.
    print(items)
    # The above line will list the dropped items in the debug console. You can access this console from the Dropzone settings menu
    # or by pressing Command+Shift+D after clicking the Dropzone status item
    # Printing things to the debug console with print is a good way to debug your script. 
    # Printed output will be shown in red in the console

    # You mostly issue commands to Dropzone to do things like update the status - for example the line below tells Dropzone to show
    # the text "Starting some task" and show a progress bar in the grid. If you drag a file onto this action now you'll see what I mean
    # All the possible dz methods are described fully in the API docs (linked up above)
    dz.begin("Renaming files...")
    
    _run(items)

    # The below line tells Dropzone to end with a notification center notification with the text "Task Complete"
    dz.finish("Done")

    # You should always call dz.url or dz.text last in your script. The below dz.text line places text on the clipboard.
    # If you don't want to place anything on the clipboard you should still call dz.url(false)
    dz.url(False)
 
def clicked():
    dz.begin("Renaming files in ~/Desktop...")
    _run([os.path.expanduser("~/Desktop")])
    # This method gets called when a user clicks on your action
    dz.finish("Done")
    dz.url(False)
    
def _run(files):
    dz.determinate(True)
        

    # Below line switches the progress display to determinate mode so we can show progress
    # dz.determinate(True)

    # Below lines tell Dropzone to update the progress bar display
    # dz.percent(10)
    
    for i, file in enumerate(files):
        if os.path.isdir(file):
            _rename_dir(file)
        elif os.path.isfile(file):
            _rename_file(file)

def _rename_dir(dir):
    for root, dirs, files in os.walk(dir):
        for i, d in enumerate(dirs):
            _rename_dir(os.path.join(root, d))
        for i, f in enumerate(files):
            _rename_file(os.path.join(root, f))
        
def _rename_file(file):
    if (os.path.basename(file).endswith("]")):
        match = re.match(r'.+\.([a-z]+)\s\[([0-9]+)\]$', file)
        if match:
            ext = match.group(1)
            num = match.group(2)
            renamed = file.replace("." + ext + " [" + num + "]", " [" + num + "]." + ext)
            os.rename(file, renamed)
