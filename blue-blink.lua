-- Config
local pin = 4            --> GPIO2
local duration = 1000    --> 1 second
local i = 0              --> counter to show
 
-- Function toggles LED state
function toggleLED ()
  if i%25==0 then print("stop with: tmr.stop(0)...") end
  gpio.write(pin, i%2)
  i = i + 1
  print("i = "..i)
end
 
-- Initialise the pin
gpio.mode(pin, gpio.OUTPUT)
 
-- Create an interval
tmr.alarm(0, duration, 1, toggleLED)