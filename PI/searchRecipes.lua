local composer = require( "composer" )
local widget = require( "widget" )
local sqlite3 = require "sqlite3"
local path = system.pathForFile( "CICI", system.ResourceDirectory )
local db = sqlite3.open(path)
local scene = composer.newScene()
local tableView
local ingredients = {}

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
-- Key listener for back Button
  local function onKeyEvent( event )
      local phase = event.phase
      local keyName = event.keyName


      if(keyName=="back") then
      composer.gotoScene( "mainMenu" )

      end
      return true
   end
 Runtime:addEventListener( "key", onKeyEvent );

--Handles the press of the Button
local function listRecipes( event  )
  if ( "ended" == event.phase ) then
    if ( #ingredients ~= 0 ) then --if no ingredient is selected do nothing when button press (#table -> table size)
      composer.setVariable("ingredients", ingredients)
      composer.gotoScene("listRecipesB")
    end
  end
end

--Handles the checkbox button press event
local function onSwitchPress( event )
  local switch = event.target
  local thisRow = tableView:getRowAtIndex( switch.rowID )

  if switch.isOn == false then
    thisRow.params.isSwitchOn = false
    table.remove(ingredients, 1)
  else
    thisRow.params.isSwitchOn = true
    table.insert(ingredients, tableView:getRowAtIndex(switch.rowID).params.name)
  end
end

--Render a line with DB data
local function onRowRender( event )

  -- Get reference to the row group
  local row = event.row
  local params = event.row.params

  -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
  local rowHeight = row.contentHeight
  local rowWidth = row.contentWidth

  -- create checkbox
  local checkboxButton = widget.newSwitch(
  {
    style = "checkbox",
    id = "Checkbox",
    onPress = onSwitchPress
  }
)
checkboxButton.anchorX = 0
checkboxButton.x = 0
checkboxButton.y = rowHeight * 0.5

--button State
checkboxButton.rowID = row.id
checkboxButton.isOn = row.params.isSwitchOn
if ( row.params.isSwitchOn == true ) then
  checkboxButton:setState( { isOn=true } )
else
  checkboxButton:setState( { isOn=false } )
end
row:insert(checkboxButton)

--Ingredients Name
local rowTitle = display.newText( row, params.name, 0, 0, nil, 14 )
rowTitle:setFillColor( 0 )

-- Align the label left and vertically centered
rowTitle.anchorX = 0
rowTitle.x = 40
rowTitle.y = rowHeight * 0.5
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

  local sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen

  --Background Image
  bg = display.newImage( "background1.jpg" )
  bg.x = display.contentCenterX
  bg.y = display.contentCenterY
  sceneGroup:insert(bg)

  --Create a table with the ingredients
  tableView = widget.newTableView(
  {
    left = 0,
    top = 0,
    height = display.contentHeight,
    width = display.contentWidth,
    onRowRender = onRowRender,
    onRowTouch = onRowTouch,
    listener = tableViewListener
  }
)
sceneGroup:insert(tableView )

local listRecipesButton = widget.newButton(
{
  label = "Listar Receitas",
  onEvent = listRecipes,
  emboss = false,
  shape = "roundedRect",
  width = 140,
  height = 39,
  cornerRadius = 2,
  fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
  strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
  strokeWidth = 4
}
)

listRecipesButton.x = display.contentWidth * 0.5
listRecipesButton.y = display.contentHeight * 1.05
sceneGroup:insert(listRecipesButton)

-- Insert Recipes
for row in db:nrows("SELECT * FROM Ingredientes") do
  -- Insert a row into the tableView
  tableView:insertRow{
    params = {
      name = row.Nome
    }
  }
end

end

-- show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)

  elseif ( phase == "did" ) then
    -- Code here runs when the scene is entirely on screen

  end
end


-- hide()
function scene:hide( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is on screen (but is about to go off screen)

  elseif ( phase == "did" ) then
    -- Code here runs immediately after the scene goes entirely off screen

  end
end


-- destroy()
function scene:destroy( event )

  local sceneGroup = self.view
  -- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
