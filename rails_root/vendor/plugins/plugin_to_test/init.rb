init_path = PluginTestEnvironment.plugin_path + "/init.rb" #

silence_warnings { eval(IO.read(init_path), binding, init_path) }