-- script to put on a computer or tablet to control a turtle
-- this is only intended to work on the tablet sizing wise as I dont want to
-- make a responsive environment

-- current tablet state, too lazy to manage this properly
STATE = {
  debug = {},
  inventory = {},
  selectedTab = "tab_main",
  activeKey = {}
}

--  main control tab    -> remote control looking screen
--  inventory tab       -> view the inventory of the turtle
--  turtle select tab   -> select what turtle to control
--  debug tab           -> see more detailed output from actions
--  command tab         -> send commands directly to the turtle's shell
--  help tab
TABS = {
  ["tab_main"] = "M",
  ["tab_inventory"] = "I",
  ["tab_select"] = "S",
  ["tab_command"] = "$",
  ["tab_debug"] = "#",
  ["tab_help"] = "?"
}
TAB_Y = 1      -- y level to draw tabs at
TAB_HEIGHT = 1 -- at least 1
TAB_WIDTH = 3  -- should be odd
TAB_COLOR = colors.gray
TAB_ACTIVE_COLOR = colors.green

-- track all window objects
WINDOW_OBJECTS = {}

-- debug with rednet messages
peripheral.find("modem", rednet.open)
function debug(message)
  rednet.broadcast(message, "debug_tablet")
end

-- find or create a window object
-- i imagine these arent supposed to be used like this but
-- oh well not my problem
function winOBJ_findOrCreate(name, x, y, width, height)
  local obj = nil
  local created = false
  if WINDOW_OBJECTS[name] ~= nil then
    obj = WINDOW_OBJECTS[name].window
  else
    obj = window.create(term.current(), x, y, width, height)
    created = true
    WINDOW_OBJECTS[name] = { window = obj }
  end
  return created, obj
end

-- attach a click event to a window object
function winOBJ_addClickEvent(windowName, handler)
  if WINDOW_OBJECTS[windowName] ~= nil then
    WINDOW_OBJECTS[windowName].clickEvent = handler
  end
end

-- check if a click collides with any active window objects
function checkClickCollide(cx, cy)
  for k, v in pairs(WINDOW_OBJECTS) do
    local x, y = v.window.getPosition()
    local w, h = v.window.getSize()
    if cx >= x and cx < x + w and cy >= y and cy < y + h then
      -- we in the box
      -- TODO decide how to check active? Visible? idk
      if v.clickEvent == nil then
        goto continue
      end
      return WINDOW_OBJECTS[k]
    end
    ::continue::
  end
  return nil
end

-- process a click event
function processClick(button, x, y)
  local obj = checkClickCollide(x, y)
  if obj == nil then
    return
  end

  if obj.clickEvent == nil then
    return
  end

  obj.clickEvent(button, x, y)
end

-- handle a tab being clicked by setting it to the active tab and redrawing tabs
function handleTabClick(tabname)
  return function(button, x, y)
    debug(button .. "," .. x .. "," .. y)
    if STATE.selectedTab ~= tabname then
      STATE.selectedTab = tabname
      drawTabs()
    end
  end
end

-- draw tabs at the top of the screen
function drawTabs()
  local x = 1
  -- TODO link this to tab width in tab.write below, just lazy rn
  local padding = math.floor(TAB_WIDTH / 2)
  local w, h = term.getSize()
  local created , bar = winOBJ_findOrCreate("tab_background", 1, 1, w, 1)
  bar.setBackgroundColor(TAB_COLOR)
  bar.setTextColor(TAB_COLOR)
  bar.write("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
  for key, icon in pairs(TABS) do
    local created, tab = winOBJ_findOrCreate(key, x, TAB_Y, TAB_WIDTH, TAB_HEIGHT)

    -- pick the bg color of the tab
    local color = TAB_COLOR
    if STATE.selectedTab == key then
      color = TAB_ACTIVE_COLOR
    end
    tab.setBackgroundColor(color)
    tab.setTextColor(colors.black)
    tab.setCursorPos(1,1)
    tab.write(" " .. icon .. " ")

    -- things we only need to do once
    if created then
      -- TODO
      winOBJ_addClickEvent(key, handleTabClick(key))
    end

    tab.redraw()

    -- iter
    x = x + TAB_WIDTH
  end
end

function drawInventory()

end

function drawController()

end

function drawSelect()

end

function drawDebug()
  -- state
end

function drawCommand()

end

function drawMenu()

end

function remoteScan()

end


function main()
  term.clear()
  drawTabs()

  while true do
    local event, a, b, c = os.pullEvent()
    if event == "mouse_click" then
      processClick(a, b, c)
      debug("click: " .. a .. ", " .. b .. ", " .. c)
    end
  end
end

status, message = pcall(main)
debug(message)
term.clear()
term.setCursorPos(1,1)
term.write(message)