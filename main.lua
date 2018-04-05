-----------------------------------------------------------------------------------------
-- Taisei Scott
-- This program displays a math question for the user. 
--
-----------------------------------------------------------------------------------------

display.setStatusBar(display.HiddenStatusBar)

local background = display.newImageRect("Images/background.jpg", 1180, 825)
background:scale(2, 2)
--local variables
local questionObj
local correctObj
local numericField
local randomNumber1
local randomNumber2
local userAnswer
local correctAnswer
local incorrectObj
local randomOperator
local points = 0
local pointsText

local totalSeconds = 10
local secondsLeft = 10
local clockText
local countdownTimer

local lives = 3
local life1
local life2
local life3

local wrongAudio = audio.loadSound("Audio/nope.mp3")
local rightAudio = audio.loadSound("Audio/machina.mp3")
local gameoverAudio = audio.loadSound("Audio/gameover.mp3")
local winAudio = audio.loadSound("Audio/win.mp3")

local gameover
local youWin

--local functions
local function AskQuestions()
	randomOperator = math.random(1, 4)
	--generate 2 random numbers
	randomNumber1 = math.random(1, 10)
	randomNumber2 = math.random(1, 10)

	if (randomOperator == 1) then
		correctAnswer = randomNumber1 + randomNumber2
	
		questionObj.text = randomNumber1 .. " + " .. randomNumber2 .. " = "

	elseif (randomOperator == 2) then

		if (randomNumber2 > randomNumber1) then
			correctAnswer = randomNumber2 - randomNumber1
			questionObj.text = randomNumber2 .. " - " .. randomNumber1 .. " = "
		else
			correctAnswer = randomNumber1 - randomNumber2
			questionObj.text = randomNumber1 .. " - " .. randomNumber2 .. " = "

		end

	elseif (randomOperator == 3) then
		correctAnswer = randomNumber1 * randomNumber2
	
		questionObj.text = randomNumber1 .. " x " .. randomNumber2 .. " = "

	elseif (randomOperator == 4) then
		correctAnswer = randomNumber1 * randomNumber2
	
		questionObj.text = correctAnswer.. " / " .. randomNumber2 .. " = "
		correctAnswer = randomNumber1

	end

end

--win game
local function YouWin()
	youWin.isVisible = true
	numericField.isVisible = false
	clockText.isVisible = false
	timer.cancel(countdownTimer)
	audio.play(winAudio)
end

--points
local function Points()
	pointsText.text = "Points:" .. points
	points = points + 1
	if (points == 11) then
		YouWin()
	end
end

--Game Over
local function GameOver ()
	if (lives == -1) then
		gameover.isVisible = true
		numericField.isVisible = false
		clockText.isVisible = false
		timer.cancel(countdownTimer)
		timer.performWithDelay(1000, winAudio)
	end
end

local function UpdateHeart()
	if (lives == 2) then
		life1.isVisible = false
		life2.isVisible = true
		life3.isVisible = true
	elseif (lives == 1) then
		life1.isVisible = false
		life2.isVisible = false
		life3.isVisible = true
	elseif (lives == 0) then
		life1.isVisible = false
		life2.isVisible = false
		life3.isVisible = false			
	end
	GameOver()
end

local function HideCorrect()
	correctObj.isVisible = false
	incorrectObj.isVisible = false
	AskQuestions()
end

local function UpdateTime ()
	secondsLeft = secondsLeft - 1
	clockText.text = secondsLeft .. ""

	if (secondsLeft == 0) then
		secondsLeft = totalSeconds
		audio.play(wrongAudio)
		lives = lives - 1
		UpdateHeart()
		AskQuestions()

	end
end

--calls the timer
local function StartTimer()
	countdownTimer = timer.performWithDelay (1000, UpdateTime, 0)	
end

local function ResetTimer()
	secondsLeft = totalSeconds
end

local function NumericFieldListener( event )
	--user begins editing field
	if (event.phase == "began") then
	
	elseif event.phase == "submitted" then


		--when answer is submitted(enter), set user imput to userAnswer
		userAnswer = tonumber(event.target.text)

		--clear text
		event.target.text = ""

		--user answer is correct
		if (userAnswer == correctAnswer) then
			correctObj.isVisible = true
			audio.play(rightAudio)
			ResetTimer()
			Points()
			timer.performWithDelay(2000, HideCorrect)
		else
			incorrectObj.isVisible = true
			audio.play(wrongAudio)
			lives = lives - 1
			UpdateHeart()
			ResetTimer()
			timer.performWithDelay(2000, HideCorrect)		

		end
	end
end


--objects

--Displays the question
questionObj = display.newText ("", display.contentWidth/3, display.contentHeight/2, nil, 70)
questionObj:setTextColor(0, 0, 0)

--Correct text, invisible
correctObj = display.newText("Correct!", questionObj.x, questionObj.y+100, nil, 50)
correctObj:setTextColor(1, 1, 0)
correctObj.isVisible = false

--incorrect text, invisible
incorrectObj = display.newText("Incorrect!", questionObj.x, questionObj.y+100, nil, 50)
incorrectObj:setTextColor(1, 1, 0)
incorrectObj.isVisible = false

--point text
pointsText = display.newText("", display.contentCenterX, display.contentCenterY/2, nil, 70)
pointsText:setTextColor(0, 0, 0)

--numeric field
numericField = native.newTextField(display.contentWidth/2, display.contentHeight/2, 150, 80)
numericField.inputType = "number"
numericField.isVisible = true

numericField:addEventListener("userInput", NumericFieldListener)

life1 = display.newImageRect("Images/heart.png", 130, 130)
life1.x = display.contentWidth*5/8
life1.y = display.contentHeight*1/7

life2 = display.newImageRect("Images/heart.png", 130, 130)
life2.x = display.contentWidth*6/8
life2.y = display.contentHeight*1/7

life3 = display.newImageRect("Images/heart.png", 130, 130)
life3.x = display.contentWidth*7/8
life3.y = display.contentHeight*1/7

gameover = display.newImageRect ("Images/gameover.png", 400, 300)
gameover.x = display.contentCenterX
gameover.y = display.contentCenterY
gameover:scale(3, 3)
gameover.isVisible = false

youWin = display.newImageRect ("Images/YouWin.png", 620, 350)
youWin.x = display.contentCenterX
youWin.y = display.contentCenterY
youWin:scale(2.3, 2.3)
youWin.isVisible = false

clockText = display.newText("", display.contentWidth*1/5, display.contentHeight*1/8, nil, 50)
clockText:setTextColor(1, 1, 0)


--Function Calls

--call the function Ask Question
AskQuestions()
UpdateTime()
StartTimer()
UpdateHeart()
GameOver()
Points()