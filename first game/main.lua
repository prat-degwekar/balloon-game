-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local background = display.newImage("images/clouds.png" , display.contentCenterX , display.contentCenterY);

display.setStatusBar(display.HiddenStatusBar);

local physics = require( "physics" )

physics.setDrawMode( "normal" )

system.activate( "multitouch" )

balloons = 0
numBalloons = 100

startTime = 15
totalTime = 15

timeLeft = true

playerReady = false

Random = math.random

local music = audio.loadStream( "sounds/music.mp3" )

local balloonPop = audio.loadSound( "sounds/balloonPop.mp3" )

local screenText = display.newText( "Loading..." , 100 , 50 , native.systemFont , 32 )
screenText.xScale = 0.5
screenText.yScale = 0.5
--screenText:setReferencePoint( display.BottomLeftReferencePoint )
screenText.x = --[[display.contentWidth/2 - 20--]]75
screenText.y = display.contentHeight - 15

local timeText = display.newText("Time : "..startTime , 0 , 0 , native.systemFont , 16*2 )
timeText.xScale = 0.5
timeText.yScale = 0.5
timeText.x = display.contentWidth/2
timeText.y = display.contentHeight - 15


local gameTimer;

-- Did the player win or lose the game?
local function gameOver(condition)
	-- If the player pops all of the balloons they win
	if (condition == "winner") then
		screenText.text = "Amazing!";
	-- If the player pops 70 or more balloons they did okay
	elseif (condition == "notbad") then
		screenText.text = "Not too shabby."
	-- If the player pops less than 70 balloons they didn't do so well
	elseif (condition == "loser") then
		screenText.text = "You can do better.";
	end
end 

-- Remove balloons when touched and free up the memory they once used
local function removeBalloons(obj)
	obj:removeSelf();
	-- Subtract a balloon for each pop
	balloons = balloons - 1;
	
	-- If time isn't up then play the game
	if (timeLeft ~= false) then
		-- If all balloons were popped
		if (balloons == 0) then
			timer.cancel(gameTimer);
			gameOver("winner")
		elseif (balloons <= 30) then
			gameOver("notbad");
		elseif (balloons >=31) then
			gameOver("loser");
		end
	end
end

local function countDown(e)
	-- When the game loads, the player is ready to play
	if (startTime == totalTime) then
		-- Loop background music
		audio.play(music, {loops =- 1});
		playerReady = true;
		screenText.text = "Hurry!"
	end
	-- Subtract a second from start time
	startTime = startTime - 1;
	timeText.text = "Time: "..startTime;
	
	-- If remaining time is 0, then timeLeft is false 
	if (startTime == 0) then
		timeLeft = false;
	end
end


--physics part

physics.start()

physics.setGravity(0 , -5)

local function startGame()
	local myBalloon = display.newImageRect( "images/balloon.png" , 25 , 25 )
	myBalloon.x = Random(50 , display.contentWidth - 25 )
	myBalloon.y = display.contentHeight - 10
	physics.addBody( myBalloon , "dynamic" , { density = 0.1 , friction = 0.0 , bounce = 0.9 , radius = 10 } )
	
	function myBalloon:touch(e)
		-- If time isn't up then play the game
		if (timeLeft ~= false) then
			-- If the player is ready to play, then allow the balloons to be popped
			if (playerReady == true) then
				if (e.phase == "ended") then
					-- Play pop sound
					audio.play(balloonPop);
					-- Remove the balloons from screen and memory
					removeBalloons(self);
				end
			end
		end
	end
	-- Increment the balloons variable by 1 for each balloon created
	balloons = balloons + 1;
	
	-- Add event listener to balloon
	myBalloon:addEventListener("touch", myBalloon);
	
	if (balloons == numBalloons) then
		gameTimer = timer.performWithDelay(1000, countDown, totalTime);
	else
		-- Make sure timer won't start until all balloons are loaded
		playerReady = false;
	end
	
end

gameTimerr = timer.performWithDelay( 20 , startGame , numBalloons )

local leftWall = display.newRect( 10 , display.contentCenterY , 1 , display.contentHeight )
local rightWall = display.newRect( display.contentWidth - 10 , display.contentCenterY , 1 , display.contentHeight )
local ceiling = display.newRect( display.contentCenterX , 10 , display.contentWidth , 1 )

physics.addBody ( leftWall , "static" , { bounce = 0.5 } )
physics.addBody ( rightWall , "static" , { bounce = 0.5 } )
physics.addBody ( ceiling , "static" , { bounce = 0.5 } )