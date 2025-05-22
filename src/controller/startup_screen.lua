TURTLE = {
  "y\97b\8C\8C\8C\8C\96o\80", -- start y back
  "y\95\95\80\80b\95\95y\95", -- start y back
  "y\95\95\80\80b\95\95y\95", -- start y back
  "b\8A\8C\8C\8C\8C\85o\80"   --start b back
}

COLOR_MAP = {
  ["y"] = { colors.yellow, colors.black },
  ["b"] = { colors.black, colors.yellow }
}

--write a string with cursed color markers
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
  local turtleWindow = window.create(selectedTerm, 0, 0, 7, 4)
  for i = 1, #TURTLE do
    writeColorString(TURTLE[i], turtleWindow, colors.green)
    selectedTerm.write("\n")
  end
  return turtleWindow
end

function drawStartupScreen()
  local currentTerm = term.current()
  local w, h currentTerm.getSize()
  local turtle = createTurtle(currentTerm)
  local title = window.create(currentTerm, 0, 0, w, 1)
  -- todo get a better name etc
  title.write("rc turtle tm")
  -- todo move the turtle in the loading screen
end
