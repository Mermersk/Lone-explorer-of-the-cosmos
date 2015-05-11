-- Heli leikur, test með cameru og árekstra.
camera = require("camera")
require("conf")

function love.load()
        --loading in stuff and setting modes
    map = love.graphics.newImage("bord.png")
	mapData = love.image.newImageData("bord.png")
	still = love.graphics.newImage("still.jpg")
	on = love.graphics.newImage("on.jpg")
	crash = love.graphics.newImage("crashed.jpg")
	kula = love.graphics.newImage("kula.jpg")
	warp = love.graphics.newImage("warp.png")
	sud = love.audio.newSource("sud.ogg")
	com = love.audio.newSource("com.wav")
	boom = love.audio.newSource("crash.mp3")
	eng = love.audio.newSource("engage.mp3")
	
	--font
	font = love.graphics.newFont("FutureMillennium Black.ttf", 20)
	
	
	-- Beginning values
	heli_y = 70
	heli_x = 2
	heli_dy = 0
	heli = still
    
	paused = false
    
	cam = camera:new()
	cam:zoom(1.13)
	-- bara useless fyrir pásuna.
	cam:lookAt(heli_x + 400, 120)
	fps = 0
	
end

function love.update(dt)
	if paused == true then
		return
	end
    --movement/look of the craft
	heli_x = heli_x + 80 *dt
	heli_y = heli_y + heli_dy*dt
	heli = still
	
	-- what happens if I click left mouse button ?
	if love.mouse.isDown("l") then
	    heli_dy = heli_dy - 50*dt
		heli = on
		love.audio.play(com)
	else
	   heli_dy = heli_dy + 40*dt
	   love.audio.play(sud)
	   com:pause()
	end
	
	
	-- Camera functions
	cam:lookAt(heli_x + 300, 120)

	if heli_x < 100 then
	    cam:lookAt(400, 120)
	end
	
	--collision detection system
	r, g, b, a = mapData:getPixel(heli_x* 2, heli_y* 2)
	if r < 220 or g < 220 or b < 220 then
	    heli = crash
		love.audio.play(boom)
		paused = true
	end
	r, g, b, a = mapData:getPixel((heli_x + 19)* 2, (heli_y + 19)* 2)
	if r < 220 or g < 220 or b < 220 then
	    heli = crash
		love.audio.play(boom)
	    paused = true
	end
	r, g, b, a = mapData:getPixel((heli_x + 19)* 2, (heli_y)* 2)
	if r < 220 or g < 220 or b < 220 then
	    heli = crash
		love.audio.play(boom)
		paused = true
	end
	r, g, b, a = mapData:getPixel((heli_x)* 2, (heli_y + 19)* 2)
	if r < 220 or g < 220 or b < 220 then
	    heli = crash
		love.audio.play(boom)
		paused = true
	end
	
	--frames per second
	fps = love.timer.getFPS()
	
end

function love.draw()
    --Where the camera is looking
    cam:attach()
  
    love.graphics.draw(map, 0, 0, 0, 0.50, 0.50)
	love.graphics.draw(heli, heli_x, heli_y, 0, 1, 1)
	love.graphics.draw(kula, 2500, 180)
	love.graphics.draw(kula, 2560, 20, 0, 0.25, 0.25)
	love.graphics.draw(kula, 2600, 150, 0, 0.25, 0.25)
	love.graphics.draw(kula, 2700, 200, 0, 0.25, 0.25)
	love.graphics.draw(kula, 2730, 110, 0, 0.25, 0.25)


	
    cam:detach()

	love.graphics.setFont(font)
	love.graphics.setColor(70, 130, 180)
	love.graphics.print(fps, 700, 0)
	love.graphics.print("Pixels travelled: ", 300, 0)
	love.graphics.print(math.floor(heli_x), 510, 0)
	if heli_x > 2500 then
	    love.graphics.print("The ship is safe, let's get out of here", 450, 170)
	    love.graphics.print("Press E to engage warp drive", 500, 200)
	end
	love.graphics.setColor(255, 255, 255)

    if paused == true then
	    start()
	end

end
-- keypresses
function love.keypressed(key)
	if key == " " then
	    paused = false
		heli_x = 2
		heli_y = 70
		heli_dy = 0
	end
	if key == "e" then
	    love.audio.play(eng)
		love.timer.sleep(1.3)
		engage = on
		paused = true
		heli = warp
		love.audio.stop(sud)
	end
	
end

--My own function, the end/start screen
function start()
    love.graphics.print("Press Space to engage/restart engines", 260, 100)
	love.graphics.print("Use the left mouse button to thrust", 260, 120)
	love.graphics.print("You explored          pixels of space", 260, 200)
	love.graphics.print(math.floor(heli_x), 420, 200)
	love.graphics.setColor(70, 130, 180)
end

