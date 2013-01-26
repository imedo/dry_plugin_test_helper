PluginTestEnvironment::Migration.setup do

  create_table "cats", :force => true do |t|
    t.column "name", :string
    t.column "lol_factor",   :integer
  end

end
