local composer = require( "composer" )
local widget = require("widget")
local sqlite3 = require "sqlite3"

local scene = composer.newScene()
local id = composer.getVariable( "ID" )
local db = composer.getVariable( "dataBase" )

local imageFile = "db/images/" .. id .. ".jpg"
local ingredientList
local recipeName
local prepList

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- Key listener for back Button
  local function onKeyEvent( event )
      local phase = event.phase
      local keyName = event.keyName


      if(keyName=="back") then
      composer.removeScene("displayRecipe")
      composer.gotoScene( "mainMenu" )
      end
      return true
   end
 Runtime:addEventListener( "key", onKeyEvent );

--Get DB data
function databaseGet()
  for row in db:nrows("SELECT * FROM Receita WHERE ID=" .. id.. ";" ) do
    ingredientList = row.Descricao
    recipeName = row.Nome
    prepList= row.Instrucoes
  end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

  databaseGet()

  local sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen

  --Background Image
  local bg = display.newImage( "background.jpg" )
  bg.x = display.contentCenterX
  bg.y = display.contentCenterY
  sceneGroup:insert(bg)

  --Creates a ScrollView
  local scrollView = widget.newScrollView
  {
    top = 0,
    left = 0,
    width = display.contentWidth,
    height = display.contentHeight,
    scrollWidth = display.contentWidth,
    horizontalScrollDisabled = true,
    listener = scrollListener,
    hideBackground = true
  }

  --Recipe Image
  local recipeImage = display.newImageRect(imageFile, 200,200)
  recipeImage.x = display.contentCenterX
  recipeImage.y = 141
  scrollView:insert(recipeImage)

  --Recipe Title
  local titleOptions = {
    text = recipeName,
    x = display.contentCenterX,
    y = 15,
    width = display.contentWidth,
    font = native.systemFontBold,
    fontSize = 24,
    align = "center"
  }
  local titleBox = display.newText( titleOptions )
  titleBox:setFillColor( 0, 1, 0 )
  scrollView:insert(titleBox)

  --Recipe Text
  local recipeText = "Ingredientes \n\n " .. ingredientList .. "\n\n" ..  "Preparação" .. "\n\n".. prepList
  local textoptions ={
    text = recipeText,
    x = display.contentCenterX,
    width = display.contentWidth,
    font = native.systemFont,
    fontSize = 15,
    align = "left"
  }
  local len = string.len(recipeText)
  if len < 600 then
    textoptions.y = 440
  elseif len < 800 then
    textoptions.y = 550
  else
    textoptions.y = 770
  end

  local recipeTextBox =  display.newText(textoptions)
  scrollView:insert(recipeTextBox)

  sceneGroup:insert(scrollView)
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
