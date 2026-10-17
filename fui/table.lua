require("base")
require("localizer")

FUITable = class(FUIBase)

local function sort_direction_caption(direction)
  if direction then return " [▴]" end
  return " [▾]"
end

function FUITable:initialize(name, parent, caption, style, columns)
  self.super.initialize(self, name, parent)
  self.localizer = FUILocalizer.new(self:get_player(), self)
  self.style = style
  self.caption = caption
  self.columns = columns
  self.data = {}
  self.sorted_column = nil
  self.sort_ascending = false
  self.root_gui = nil
  self.table_gui = nil
  self.scroll_gui = nil
  self.cell_renders = {
      text = self.render_cell_text,
      localised_text = self.render_cell_localised_text,
      sprites = self.render_cell_sprites
    }
  self:add_handler("sort_by", self.sort_by)
end

function FUITable:add_row(row_data)
    table.insert(self.data, row_data)
end

function FUITable:sort_by(column_index)
  -- if self.columns[column_index].type ~= "text" then return end
  if self.sorted_column == column_index
  then
    self.sort_ascending = not self.sort_ascending
  else
    self.sorted_column = column_index
    self.sort_ascending = true
  end

  table.sort(self.data, function(a, b)
      if self.sort_ascending then
          return a[column_index].content < b[column_index].content
      else
          return a[column_index].content > b[column_index].content
      end
  end)
  self:update()
end

function FUITable:update()
  -- log(serpent.block(self.data))
  if self.root_gui == nil
  then
    self.root_gui = self.parent.add{type = "flow", direction = "vertical"}
    self.root_gui.add{type = "label", caption = self.caption}
    self.scroll_gui = self.root_gui.add{type = "scroll-pane", name = self.name .. "_scroll", style = "scroll_pane"}
    self.root_gui.style.maximal_height = self:get_player().display_resolution.height - 200
    -- self.root_gui.style.vertically_stretchable = true
  end
  if self.table_gui ~= nil then self.table_gui.destroy() end
  self.table_gui = self.scroll_gui.add{
    type = "table",
    name = self.name .. "_table",
    style = self.style,
    column_count = #self.columns,
    vertical_centering = true
  }
  for i, column in ipairs(self.columns)
  do
    local label_caption = column.caption
    if self.sorted_column == i
    then
      label_caption = label_caption .. sort_direction_caption(self.sort_ascending)
    end
    local label = self.table_gui.add{type = "label", caption = label_caption}
    if column.type == "text" or column.type == "localised_text"
    then
      label.tags = {
        handler = self.name,
        handler_method = "sort_by",
        handler_arguments = { i }
      }
    end
  end
  for row_index, row in ipairs(self.data)
  do
    for column_index, cell in ipairs(row)
    do
      self:render_cell(row_index, column_index, cell)
    end
  end
end

function FUITable:render_cell(row_index, column_index, cell)
  local cell_render = (self.cell_renders[self.columns[column_index].type] or self.render_cell_default)
  self:render_cell_meta(row_index, column_index, cell, cell_render(self, row_index, column_index, cell))
end

function FUITable:render_cell_text(row_index, column_index, cell)
  local cell_content = cell.content
  if type(cell_content) == "number" and cell_content%1 > 0
  then
    cell_content = string.format("%.2f", cell_content)
  end
  return self.table_gui.add{type = "label", caption = cell_content}
end

function FUITable:render_cell_localised_text(row_index, column_index, cell)
  local caption = "..."
  if type(cell.content) == "string"
  then
    caption = cell.content
  else
    self.localizer:request_translation(cell.content, self.localize_cell, {row = row_index, column = column_index})
  end
  local label = self.table_gui.add{type = "label", caption = caption}
  cell.label = label
  return label
end

function FUITable:localize_cell(data, text)
  self.data[data.row][data.column].content = text
  self.data[data.row][data.column].label.caption = text
end

function FUITable:render_cell_sprites(row_index, column_index, cell)
  local sprite_parent = self.table_gui
  -- local result = nil
  for _, sprite in ipairs(cell.content)
  do
    sprite_parent = sprite_parent.add{
      type             = 'sprite',
      style            = sprite.style,
      sprite           = sprite.path,
      resize_to_sprite = false
    }
    -- if not result then result = sprite_parent end
  end
  -- return (result or sprite_parent)
  return sprite_parent
end

function FUITable:render_cell_default(row_index, column_index, cell)
  return self.table_gui.add{type = "label", caption = serpent.block(cell)}
end

function FUITable:render_cell_meta(row_index, column_index, cell, element)
  if cell.elem_tooltip then element.elem_tooltip = cell.elem_tooltip end
  if cell.tooltip then element.tooltip = cell.tooltip end
end
