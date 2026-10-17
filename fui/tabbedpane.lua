require("base")

FUITabbedPane = class(FUIBase)

function FUITabbedPane:initialize(name, parent, container_style, tab_style, flow_style, tabs)
  self.super.initialize(self, name, parent)
  self.tabs = {}
  self.captions = tabs
  self:init_tabs(container_style, tab_style, flow_style)
end

function FUITabbedPane:init_tabs(container_style, tab_style, flow_style)
  self.root_gui = self.parent.add{
    type = "tabbed-pane",
    name = self.name,
    style = container_style
  }

  for i, tab in ipairs(self.captions)
  do
    local tab = self.root_gui.add{
      type = "tab",
      caption = tab.caption,
      name = self.name .. "_tab_" .. (tab.name or i),
      style = tab_style
    }

    local flow = self.root_gui.add{
      type = "flow",
      name = self.name .. "_tab_flow_" .. (tab.name or i),
      style = flow_style
    }
    self.root_gui.add_tab(tab, flow)

    table.insert(self.tabs, flow)

  end

end

function FUITabbedPane:tab(what)
  if type(what) == "number" then return self.tabs[what] end
  for i, tab in ipairs(self.captions)
  do
    if (tab.name    and tab.name    == what) or
       (tab.caption and tab.caption == what)
    then return self.tabs[i] end
  end
  return nil
end
