
require("utils.class")
require("handlers")

FUIBase = class()

function FUIBase:initialize(name, parent)
  self.name = script.mod_name .. "-fui-" .. name
  self.parent = self:get_gui_parent(parent)
  self.root_gui = nil
  self.handlers = {}
  _G.GUIHandler[self.name] = self
end

function FUIBase:add_handler(name, callback)
  self.handlers[name] = callback
end

function FUIBase:notify(tags)
  if tags.handler_arguments
  then
    self.handlers[tags.handler_method](self, table.unpack(tags.handler_arguments))
  else
    self.handlers[tags.handler_method](self)
  end
end

function FUIBase:get_gui_parent(parent)
  if parent.root_gui then return parent.root_gui end
  return parent
end

function FUIBase:get_player()
  return game.get_player(self.parent.player_index)
end


function FUIBase:update() end
