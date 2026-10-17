
require("utils.string")

_G.GUIHandler = {}

function GUI_event_handler(tags)
  if tags.handler == nil then return end
  if _G.GUIHandler[tags.handler] == nil then return end
  _G.GUIHandler[tags.handler].notify(_G.GUIHandler[tags.handler], tags)
end

_G.Localizers = {}

function GUI_translation_handler(id, text)
  if _G.Localizers[id]
  then
    _G.Localizers[id].localize(_G.Localizers[id], id, text)
  end
end

--- Notifyes
function fui_event_on_gui_click_notify(event)
  if event.element.tags.handler ~= nil then GUI_event_handler(event.element.tags) end
end

function fui_event_on_gui_closed_notify(event)
  if event.element == nil or not event.element.valid or not event.element.name:contains("-fui-") then return end
  event.element.destroy()
end

function fui_event_on_string_translated_notify(event)
  GUI_translation_handler(event.id, event.result)
end
