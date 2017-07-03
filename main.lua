-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local halfW = display.contentWidth / 2
local halfH = display.contentHeight / 2

local backgroundImage = "night sky.png"			-- Background image name saved in project folder

-- Balloon image attributes

local balloonImage = "balloon_red.png"			-- Image of the ballon placed inside the project folder

local imageX = 100								-- X and Y size of image rectangle
local imageY = 150

local balloonStartX = halfW						-- X coordinate of start position of balloon
local balloonStartY = halfH * 1.1				-- Y coordinate of start position of balloon

-- Balloon text attributes

local balloonTextSize = 48						-- Size of text that appears inside the balloon

local balloonTextXScale = 0.5					-- x and y scale of text inside the balloon
local balloonTextYScale = 0.5

local balloonTextStartX = 0						-- Start coordinate of text inside balloon
local balloonTextStartY = 0

-- Balloon attributes

local requiredSpeed = 60						-- Change this to change speed of balloon

local numberOfBalloons = 3						-- 0 for infinite and some positive value for those many balloons

local balloonTime = 3000						-- Number of milliseconds gap between two balloons

local numberOfIterations = 20					-- Number of balloons to make through timer call

local balloonLifeTime = 200						-- Amount of time balloon needs to stay alive after hitting ceiling

-- Score display attributes

local score = 0									-- Variable keeping track of the score

local scoreFont = "Helvetica"					-- Font in which score is displayed
local scoreTextSize = 32						-- Size of score text displayed



-- Physics engine attributes

local gravityX = -0.2							-- Physics engine gravity values
local gravityY = -1

local drawMode = "normal"						-- Physics draw mode - either "normal" , "hybrid" or "debug"

-- Gravity Booster attributes

local gravityXBoosterLeft = -25					-- gravity boosting from value for horizontal gravity
local gravityXBoosterRight = 25					-- gravity boosting to value for horizontal gravity

local gravityYBoosterLeft = -3					-- gravity boosting from value for vertical gravity
local gravityYBoosterRight = 3					-- gravity boosting to value for vertical gravity


-- Left Wall attributes

local leftWallXPosition = -20						-- Location of left wall
local leftWallYPosition = display.contentCenterY
local leftWallXWidth = 1
local leftWallYWidth = halfH * 2

local leftWallBounce = 1						-- Bounce attribute on left wall

-- Right wall attributes

local rightWallXPosition = halfW * 2 + 20
local rightWallYPosition = display.contentCenterY
local rightWallXWidth = 1
local rightWallYWidth = halfH * 2

local rightWallBounce = 1						-- Bounce attribute on right wall

-- Ceiling attributes

local ceilingXPosition = display.contentCenterX
local ceilingYPosition = -1
local ceilingXWidth = halfW * 2
local ceilingYWidth = 1

local ceilingBounce = 1							-- Bounce on ceiling

-- Exit button attributes

local exitButtonX = 45
local exitButtonY = halfH * 1.7
local exitButtonSound = audio.loadSound( "balloonPop.mp3" )

-- Clear Button attributes

local clearButtonX = halfW * 1.7
local clearButtonY = halfH * 1.7
local clearButtonSound = audio.loadSound( "balloonPop.mp3" )

-- Pause Button attributes

local pauseButtonX = halfW
local pauseButtonY = halfH * 1.85
local pauseButtonSound = audio.loadSound( "balloonPop.mp3" )

-- Game controls

local endGame = 0
local clearBalloons = 0
local pauseGame = 0



-- End of attribute definition

-- Actual logic Code starts here

local background = display.newImage( backgroundImage , halfW , halfH )

display.setStatusBar( display.HiddenStatusBar )

local physics = require( "physics" )

system.activate( "multitouch" )

Random = math.random

local pop = audio.loadSound( "balloonPop.mp3" )

local startTime = 0

local screenText = display.newText( "Loading..." , 100 , 50 , native.systemFont , 32 )
screenText.xScale = 0.5
screenText.yScale = 0.5
screenText.x = --[[display.contentWidth/2 - 20--]]75
screenText.y = display.contentHeight - 15

--[[
local timeText = display.newText( "Time : "..startTime , 100 , 50 , native.systemFont , 32 )
screenText.xScale = 0.5
screenText.yScale = 0.5
screenText.x = 155  	--display.contentWidth/2 - 20
screenText.y = display.contentHeight - 15
--]]

local function removeBalloon( obj , i )
	
	if( i == 0 ) then
		
		return i+1
		
	end
	
	print( "i = "..i)
	obj:removeSelf()

end

local function cus_timer(e)
	
	startTime = startTime + 1

end

--physics part

physics.start()

physics.setGravity( gravityX , gravityY )

physics.setDrawMode( drawMode )

local j = 0

local function gravityScaleZero( balloonObj )
	
	j = j + 1
	balloonObj.gravityScale = 0
	--print( "here : "..j )
	return
	
end

local k = 0

local function removeSecondTime( myObj )

	k = k + 1
	
	if( k % balloonLifeTime == 0 ) then
		
		Runtime:removeEventListener( "enterFrame" , myObj )
		myObj:removeSelf()
		print( " removed second time for k = "..k )
		
	end
	
end

function deleteBalloon( obj )
	
		if( obj.y == nil or obj.y < 0 ) then
			
			print( "obj y : "..obj.y )
			return
			
		end
		
		if( obj.y < 80 or obj.y > halfH * 1.7 ) then 
		
			--print( "obj removeSelf y : "..obj.y )
			--obj:removeSelf()
			timer.performWithDelay( 10 , removeSecondTime( obj ) , 1 )				--10 and 1 don't matter
			
		end
		
		--print( "1" )
		
end

local function printYLocation( obj )
		
		print( " y location : "..obj.y )
		
end


local function createBalloon()							--creates ballon and text, adds physics to it, but still exists even if it is not seen

	local myGroup = display.newGroup()
	
	local function offscreen(self, event)				--checks if balloon is off the screen , removes balloon after 5 seconds on screen
		if(self.y == nil) then
			return
		end
		if(self.y < -70) then							--change this to fit the bill
			Runtime:removeEventListener( "enterFrame", self )
			self:removeSelf()
		end
		
		--[[if( self.y > halfH * 2.5 ) then
			
			physics.setGravity( gravityX , gravityY * 10 )
			self.gravityScale = 200
			physics.setGravity( gravityX , gravityY )
			print( "one has gone below the line" ) 
			
		end--]]
		
		if( endGame == 1 ) then
		
			self:removeSelf()							-- Code to save all un-touched balloons
			Runtime:removeEventListener( "enterFrame" , self )
			--print( "removed Myself" )
			
		end
		
		if( clearBalloons == 1 ) then
		
			Runtime:removeEventListener( "enterFrame" , self )		
			self:removeSelf()							-- Code to save all untouched balloons
			
		end
		
		timer.performWithDelay( 10 , deleteBalloon( self ) , 1 )			-- 10 and 1 don't matter
		timer.performWithDelay( 10 , gravityScaleZero( self ) , 1 )			-- Same here
		
		--screenText.text = "y location = "..self.y 
		
	end
	
	
	
	
	function myGroup:touch(e)							--removes balloon when finger removed
		
		if( e.phase == "ended" ) then
			
			audio.play( pop )
			--removeBalloon( self )
			Runtime:removeEventListener( "enterFrame" , e.self )
			score = score + 1							--add code to send clicked data back to inference engine
			e.target:removeSelf()
			
		end
	
	end
	
	local i = 0
	
	local myBalloon = display.newImageRect( balloonImage , imageX , imageY )
	screenText.text = " QUICK! "
	--myBalloon.x = halfW
	--myBalloon.y = halfH * 1.9
	
	local myBalloonText = display.newText("Sample Text" , balloonTextStartX  , balloonTextStartY , native.systemFont , balloonTextSize )
	myBalloonText.xScale = balloonTextXScale
	myBalloonText.yScale = balloonTextYScale
	myBalloonText.text = "free"							--use logic to get new text here (ideally through a database call)

	
	myGroup:insert( myBalloon )
	myGroup:insert( myBalloonText )
	myGroup.x = balloonStartX
	myGroup.y = balloonStartY
	myGroup.enterFrame = offscreen
	Runtime:addEventListener( "enterFrame" , myGroup )
	myGroup:addEventListener( "touch" , myGroup )
	
	physics.addBody( myGroup , "dynamic" , { density = 0.5 , friction = 0 , bounce = 0 , radius = 70 } )

	myGroup.gravityScale = requiredSpeed
	
	local gravityXBooster = Random( gravityXBoosterLeft , gravityXBoosterRight )
	print( " X gravity Boost = "..gravityXBooster )
	local gravityYBooster = Random( gravityYBoosterLeft , gravityYBoosterRight )
	--gravityX = kk * gravityX
	physics.setGravity( gravityXBooster * gravityX , gravityYBooster * gravityY )
	
	

	
end

local function displayText(e)
	
	local scoreText = display.newText( "score : "..score , halfW , halfH , scoreFont , scoreTextSize )
	
end

gTimer = timer.performWithDelay( balloonTime , createBalloon , numberOfIterations )

local function cancelTimer(e)
	
	if( e.phase == "ended" ) then
		
		audio.play( exitButtonSound )
		local res = timer.cancel( gTimer )
		endGame = 1
		--local scoreText = display.newText( "score : "..score , halfW , halfH , Helvetica , 32 )
		timer.performWithDelay( 1750 , displayText , 1 )
		print( "result : "..res )
		
	end
	
end

-- Exit Button

local exitGroup = display.newGroup()

exitButton = display.newRoundedRect( 0 , 0 , 75 , 25 , 18 )
exitButton:setFillColor (0.8 , 0.5 , 0.6 )
exitText = display.newText( "Exit" , 0 , 0 , native.systemFont , 32 )
exitText.xScale = 0.5
exitText.yScale = 0.5

exitGroup:insert( exitButton )
exitGroup:insert( exitText )
exitGroup.x = exitButtonX
exitGroup.y = exitButtonY

exitGroup:addEventListener( "touch" , cancelTimer )

-- Clear Button

local function toggleClearBit()

	if( clearBalloons == 0 ) then
		
		clearBalloons = 1
		
		print(" Clear bit : "..clearBalloons )
		
		return
		
	end
	
	if( clearBalloons == 1 ) then
	
		clearBalloons = 0
		
		print(" Clear bit : "..clearBalloons )
		
		return
		
	end
	
end

local function clearScreen( e )
	
	if( e.phase == "ended" ) then
		
		audio.play( clearButtonSound )
		
		timer.performWithDelay( 200 , toggleClearBit , 2 )
		
		-- Add code link to put all cleared balloons into saved list
		
		print( " At Clear Screen " )  
		
	end
	
end

local clearGroup = display.newGroup()

clearButton = display.newRoundedRect( 0 , 0 , 75 , 25 , 18 )
clearButton:setFillColor( 0.6 , 0.2 , 0.8 )
clearText = display.newText( "Clear" , 0 , 0 , Helvetica , 32 )
clearText.xScale = 0.5
clearText.yScale = 0.5

clearGroup:insert( clearButton )
clearGroup:insert( clearText )
clearGroup.x = clearButtonX
clearGroup.y = clearButtonY

clearGroup:addEventListener( "touch" , clearScreen )

-- Pause Button

local function pauseTimer( e )
	
	if( e.phase == "ended" ) then
		
		audio.play( pauseButtonSound )
		
		if( pauseGame == 0 ) then
		
			timer.pause( gTimer )
			
			pauseText.text = "Unpause"
			
			pauseGame = 1
			
			return
			
		end
		
		if( pauseGame == 1 ) then
		
			timer.resume( gTimer )
			
			pauseText.text = "Pause"
			
			pauseGame = 0
			
			return
			
		end
		
	end
	
end

local pauseGroup = display.newGroup()

pauseButton = display.newRoundedRect( 0 , 0 , 75 , 25 , 18 )
pauseButton:setFillColor( 0.5 , 0.3 , 0.72 )
pauseText = display.newText( "Pause" , 0 , 0 , Helvetica , 32 )
pauseText.xScale = 0.5
pauseText.yScale = 0.5

pauseGroup:insert( pauseButton )
pauseGroup:insert( pauseText )
pauseGroup.x = pauseButtonX
pauseGroup.y = pauseButtonY

pauseGroup:addEventListener( "touch" , pauseTimer )

-- sprite sheet

--[[

local sheetOptions =
{
    width = 512,
    height = 256,
    numFrames = 8
}

local sheet_runningCat = graphics.newImageSheet( "sprites-cat-running.png", sheetOptions )

local sequences_runningCat = {
    -- consecutive frames sequence
    {
        name = "normalRun",
        start = 1,
        count = 8,
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    }
}

local runningCat = display.newSprite( sheet_runningCat, sequences_runningCat )

runningCat.x = halfW * 0.75
runningCat.y = halfH * 0.7

runningCat:play()

--]]

-- Boundaries

ceiling = display.newRect( ceilingXPosition , ceilingYPosition , ceilingXWidth , ceilingYWidth )
leftWall = display.newRect( leftWallXPosition , leftWallYPosition , leftWallXWidth , leftWallYWidth )
rightWall = display.newRect( rightWallXPosition , rightWallYPosition , rightWallXWidth , rightWallYWidth )
bottomWall = display.newRect( display.contentCenterX , halfH * 2 , halfW * 2 , 1 )

physics.addBody ( ceiling , "static" , { bounce = ceilingBounce } )
physics.addBody ( leftWall , "static" , {bounce = leftWallBounce } )
physics.addBody ( rightWall , "static" , { bounce = rightWallBounce } )
physics.addBody ( bottomWall , "static" , { bounce = 0.3 } )

