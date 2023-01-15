# Dropzone Action Info
# Name: Open Application Copy 2
# Description: Allows you to open dropped files with a selected application. You can also launch the application by clicking on it in the grid.
# Handles: Files
# Creator: Aptonic Software
# URL: http://aptonic.com
# OptionsNIB: ChooseApplication
# UseSelectedItemNameAndIcon: Yes
# Events: Clicked, Dragged
# SkipConfig: No
# RunsSandboxed: Yes
# Version: 1.0
# MinDropzoneVersion: 3.0

def dragged
  files = ""
  $items.each { |file| 
    file = file.gsub(/["`$\\]/){ |s| '\\' + s }
    files += "\"#{file}\" "
  }
  application_path = "/Applications/Spark.app/Contents/MacOS/Spark"
  system("xattr -d com.apple.quarantine #{files} >& /dev/null")
  open_result = `open -a \"#{application_path}\" #{files} 2>&1`
  handle_open_result(open_result)
end

def clicked
  open_result = `open \"#{ENV['EXTRA_PATH']}\" 2>&1`
  handle_open_result(open_result)
end

def handle_open_result(open_result)
  if open_result =~ /error -10810/
    $dz.error("Open Application Manually First", "Due to sandboxing restrictions, you must open #{ENV['EXTRA_PATH']} once using the Finder before opening it with Dropzone.")
  end
end
