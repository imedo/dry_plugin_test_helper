init_path = PluginTestEnvironment.plugin_path + "/init.rb" #
init_path = PluginTestEnvironment.plugin_path + "/rails/init.rb" unless File.exist?(init_path)

silence_warnings { eval(IO.read(init_path), binding, init_path) }
