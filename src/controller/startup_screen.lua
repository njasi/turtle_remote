TURTLE = {
  "y\151b\140\140\140\140\148o\128", -- start y back
  "y\149\149\128\128b\149\149y\149", -- start y back
  "y\149\149\128\128b\149\149y\149", -- start y back
  "b\138\140\140\140\140\133o\128"   --start b back
}

COLOR_MAP = {
  ["y"] = { colors.yellow, colors.black },
  ["b"] = { colors.black, colors.yellow }
}

-- write a string with cursed color markers
-- so it works in older cc versions idk
function writeColorString(str, selectedTerm, otherColor)
  for i = 1, #str do
    local c = str:sub(i, i)

    local color = COLOR_MAP[c]
    if color ~= nil then
      selectedTerm.setBackgroundColor(color[1])
      selectedTerm.setTextColor(color[2])
    elseif c == "o" then
      selectedTerm.setBackgroundColor(otherColor)
      selectedTerm.setTextColor(otherColor)
    else
      selectedTerm.write(c)
    end
  end
end

function createTurtle(selectedTerm)
  local turtleWindow = window.create(selectedTerm, 10, 10, 7, 4)
  for i = 1, #TURTLE do
    writeColorString(TURTLE[i], turtleWindow, colors.green)
    turtleWindow.setCursorPos(1,i + 1)
  end
  return turtleWindow
end

function drawStartupScreen()
  local currentTerm = term.current()
  term.setBackgroundColor(colors.green)
  term.clear()

  local w, h = term.getSize()
  local turtle = createTurtle(currentTerm)
  local title = window.create(currentTerm, 1, 1, w, 1)
  -- todo get a better name etc
  title.write("rc turtle tm")
  -- todo move the turtle in the loading screen
  local i = w + 1
  while i > -8 do
    turtle.reposition(i, math.floor(h/2))
    i = i - 1
    sleep(0.1)
  end
end
