
require("fui.handlers")
require("fui.base")
require("fui.window")
require("fui.table")
require("fui.tabbedpane")

function fui_init_storage()
  storage = storage or {}
  storage[script.mod_name] = storage[script.mod_name] or {}
end
