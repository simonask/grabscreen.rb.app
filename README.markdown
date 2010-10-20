# How to use
## Get it

git clone git://github.com/simonask/grabscreen.rb.app.git grabscreen.rb.app

## Use it

Put the app in the Dock. Click it to initiate grab. Default mode is capture a rectangle,
press spacebar to switch to entire window mode.

If growlnotify is installed, grabscreen.rb will notify you when the screenshot was uploaded,
or if upload failed.

Press ESC to abort grab operation.

# Requirements

For now, grabscreen.rb requires the 'json' gem to be installed.

NOTE: If you have MacPorts installed, grabscreen.rb will still use the Ruby interpreter
provided by Mac OS X, and therefore also the RubyGems installation provided by the system.
You will most likely have to run "sudo /usr/bin/gem install json" before it will work.