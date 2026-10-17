require("base")

GUIWindow = class(FUIBase)

function GUIWindow:initialize(player, name, caption)
  self.super.initialize(self, name, player.gui.screen)
  if player.gui.screen[self.name] then player.gui.screen[self.name].destroy() end
  self.caption = caption
  self:add_handler("close", self.close)
  self:show()
end

function GUIWindow:show()
  self.root_gui = self.parent.add{type = "frame", name = self.name, direction = "vertical"}
  self:restore_position()
  local titlebar = self.root_gui.add{type = "flow"}
  titlebar.drag_target = self.root_gui
  titlebar.add{
    type = "label",
    style = "fui_window_caption_label",
    caption = self.caption,
    ignored_by_interaction = true,
  }
  local filler = titlebar.add{
    type = "empty-widget",
    style = "draggable_space",
    ignored_by_interaction = true,
  }
  filler.style.height = 16
  filler.style.horizontally_stretchable = true
  local close_button = titlebar.add{
    type = "sprite-button",
    name = self.name .. "-x-button",
    style = "fui_window_close_button",
    sprite = "utility/close",
    hovered_sprite = "utility/close_black",
    clicked_sprite = "utility/close_black"
  }
  close_button.tags = {
    handler = self.name,
    handler_method = "close"
  }
end

function GUIWindow:restore_position()
  if    storage[script.mod_name]
    and storage[script.mod_name][self.name]
    and storage[script.mod_name][self.name].window_position
  then
    self.root_gui.location = storage[script.mod_name][self.name].window_position
  else
    self.root_gui.auto_center = true
  end
end

function GUIWindow:close()
    if not self.root_gui or not self.root_gui.valid then return end

    if storage[script.mod_name][self.name] == nil then
        storage[script.mod_name][self.name] = {}
    end
    storage[script.mod_name][self.name].window_position = self.root_gui.location
    self.root_gui.destroy()
end
