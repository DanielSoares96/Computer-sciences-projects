local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()
local titleImage
local listRecipesButton
local searchRecipesButton
local bg

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- Button event handler
local function listRecipes( event  )
  if ( "ended" == event.phase ) then
    composer.gotoScene( "listRecipes" )
  end
end

local function searchRecipes( event  )
  if ( "ended" == event.phase ) then
    composer.gotoScene( "searchRecipes" )
  end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

  local sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen

  --Background Image
  bg = display.newImage( "background.jpg" )
  bg.x = display.contentCenterX
  bg.y = display.contentCenterY
  sceneGroup:insert(bg)

  --App Name
  titleImage = display.newText("Can I Cook It?", display.contentCenterX, 0,  native.systemFont, 50)
  sceneGroup:insert(titleImage)

  --List Recipe Button creation

  local listRecipesButton = widget.newButton(
  {
    label = "Listar Receitas",
    onEvent = listRecipes,
    emboss = false,
    shape = "roundedRect",
    width = 140,
    height = 40,
    cornerRadius = 2,
    fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
    strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
    strokeWidth = 4
  }
)

listRecipesButton.x = display.contentWidth * 0.25
listRecipesButton.y = display.contentHeight * 0.9
sceneGroup:insert(listRecipesButton)

--Search Recipe Button creation

local searchRecipesButton = widget.newButton(
{
  label = "Procurar Receitas",
  onEvent = searchRecipes,
  emboss = false,
  shape = "roundedRect",
  width = 150,
  height = 40,
  cornerRadius = 2,
  fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
  strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
  strokeWidth = 4
}
)

searchRecipesButton.x = display.contentWidth * 0.74
searchRecipesButton.y = display.contentHeight * 0.9
sceneGroup:insert(searchRecipesButton)
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
