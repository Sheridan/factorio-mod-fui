function class(parent)
  local cls = {}
  if parent then
      setmetatable(cls, {__index = parent})
      cls.super = parent
  end
  cls.__index = cls

  function cls.new(...)
      local instance = setmetatable({}, cls)
      if instance.initialize then
          instance:initialize(...)
      end
      return instance
  end
  return cls
end
