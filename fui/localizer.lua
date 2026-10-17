require("utils.class")

FUILocalizer = class()

function FUILocalizer:initialize(player, owner)
  self.player = player
  self.owner = owner
  self.callbacks = {}
end

function FUILocalizer:request_translation(localized_string, callback, data)
  local id = self.player.request_translation(localized_string)
  self.callbacks[id] = {callback = callback, data = data}
  _G.Localizers[id] = self
end

function FUILocalizer:localize(id, text)
  self.callbacks[id].callback(self.owner, self.callbacks[id].data, text)
  self.callbacks[id] = nil
  _G.Localizers[id] = nil
end
