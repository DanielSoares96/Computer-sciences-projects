local composer = require( "composer" )
local widget = require( "widget" )
local sqlite3 = require "sqlite3"
local path = system.pathForFile( "CICI", system.ResourceDirectory )
local db = sqlite3.open(path)
local scene = composer.newScene()


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

-- Table view listener
local startXpos = 0 -- Position of finger when you first touch a row
local startYpos = 0
local buffer = 5 -- How much you can move your finger around but still be counted as selected
local function tableViewListener(event)

  local phase = event.phase
  local row   = event.target

  if phase == "began" and not row.selected then

    startXpos = event.x
    startYpos = event.y
    row.selected = true

  elseif phase == "ended" or phase == "moved" then

    row.selected = false

    if phase == "ended" and event.y < startYpos + buffer and event.y > startYpos - buffer and event.x < startXpos + buffer and event.x > startXpos - buffer then
      composer.setVariable( "ID", row.index )
      composer.setVariable( "dataBase", db )
      composer.gotoScene("displayRecipe")

    end
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

  --Recipe Name
  local rowTitle = display.newText( row, params.name, 0, 0, nil, 14 )
  rowTitle:setFillColor( 0 )

  -- Align the label left and vertically centered
  rowTitle.anchorX = 0
  rowTitle.x = 10
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
  local tableView = widget.newTableView(
  {
    left = 0,
    top = 0,
    height = display.contentHeight,
    width = display.contentWidth,
    onRowRender = onRowRender,
    onRowTouch = onRowTouch,
    listener    = tableViewListener
  }
)
sceneGroup:insert(tableView )

-- Insert Recipes
for row in db:nrows("SELECT * FROM Receita") do

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
    -- Called when a key event has been received
    local function onKeyEvent( event )
        if (system.getInfo("platformName") == "Android") then
           if (event.keyName == "back") and (event.phase == "down") then

              composer.gotoScene( "mainMenu" )
                return true
           end
        end
        return false
    end

    -- Add the key event listener
    Runtime:addEventListener( "key", onKeyEvent )

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
