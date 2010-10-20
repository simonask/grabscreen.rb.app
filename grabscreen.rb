#!/usr/bin/env ruby
require 'rubygems'
require 'json'

TEMP_FILE = "/tmp/grabscreen.#{$$}.png"
GROWL_NOTIFY = "/usr/local/bin/growlnotify"
CURL = "/opt/local/bin/curl"
IMGUR_API_KEY = "42ba602ad2243f4e866a782a09455b8d"
IMGUR_UPLOAD_URL = "http://imgur.com/api/upload.json"

def notify(title, body, image = nil)
	if File.exist?(GROWL_NOTIFY)
		command = "#{GROWL_NOTIFY} -t \"#{title}\" -m \"#{body}\" -d grabscreen.rb"
		if image
			command += " --image \"#{image}\""
		end
		`#{command}`
	else
		$stdout.puts("NOTICE: #{title} -- #{body}")
	end
end

`screencapture -i -tpng #{TEMP_FILE}`

if File.exist?(TEMP_FILE)
	notify "Uploading screenshot…", TEMP_FILE, TEMP_FILE
	curl_cmd = "#{CURL} -s -F key=#{IMGUR_API_KEY} -F image=@\"#{TEMP_FILE}\" #{IMGUR_UPLOAD_URL}"
	json = nil
	IO.popen(curl_cmd, "r") { |io| json = io.read }
	if $?.success?
		result = JSON.parse json
		begin
			image_url = result["rsp"]["image"]["original_image"]
			`echo \"#{image_url}\" | pbcopy`
			notify "Screenshot uploaded!", image_url, TEMP_FILE
			File.unlink(TEMP_FILE)
		rescue
			notify "grabscreen.rb", "imgur.com responded with invalid data when uploading #{TEMP_FILE}.", TEMP_FILE
		end
	else
		notify "grabscreen.rb", "Error #{$?.exitstatus} uploading #{TEMP_FILE}.", TEMP_FILE
	end
else
	notify "grabscreen.rb", "Screen capture aborted."
end
