
data:extend({
  {
    type = "font",
    name = "fui_window_caption_font",
    from = "default-bold",
    size = 11
  }
})

local function extend_raw(type, extention)
  data.raw[type].default[extention.name] = extention
end

extend_raw('gui-style', {
  type = "label_style",
  parent = "label",
  name = "fui_window_caption_label",
  font = "fui_window_caption_font"
})

extend_raw('gui-style', {
  type = "button_style",
  parent = "close_button",
  name = "fui_window_close_button",
  size = 16,
  margin = 0
})

extend_raw('gui-style', {
  type = "tabbed_pane_style",
  parent = "tabbed_pane",
  name = "fui_tabbed_pane",
  margin = 2,
  horizontal_align = "center"
})

extend_raw('gui-style', {
  type = "tab_style",
  parent = "tab",
  name = "fui_tab",
  margin = 2,
  padding = 2
})

extend_raw('gui-style', {
  name = "fui_table_style",
  type = "table_style",
  parent = "bordered_table",
  cell_padding = 2,
  left_cell_padding = 2,
  right_cell_padding = 2,
})

-- extend_raw('gui-style', {
--   name = "fui_tab_content_flow",
--   type = "flow_style",
--   parent = "flow",
--   max_on_row = 2,
--   horizontal_spacing = 2,
--   vertical_spacing = 2
-- })
