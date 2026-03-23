Grover.configure do |config|
  config.options = {
    executable_path: "/usr/bin/chromium",
    launch_args: [ "--no-sandbox", "--disable-setuid-sandbox" ]
  }
end
