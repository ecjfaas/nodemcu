MAX7219_REG_NOOP        = 0x00
MAX7219_REG_DECODEMODE  = 0x09
MAX7219_REG_INTENSITY   = 0x0A
MAX7219_REG_SCANLIMIT   = 0x0B
MAX7219_REG_SHUTDOWN    = 0x0C
MAX7219_REG_DISPLAYTEST = 0x0F

ch0 = { 0x3E, 0x7F, 0x71, 0x59, 0x4D, 0x7F, 0x3E, 0x00 };
ch1 = { 0x40, 0x42, 0x7F, 0x7F, 0x40, 0x40, 0x00, 0x00 };
ch2 = { 0x62, 0x73, 0x59, 0x49, 0x6F, 0x66, 0x00, 0x00 };
ch3 = { 0x22, 0x63, 0x49, 0x49, 0x7F, 0x36, 0x00, 0x00 };
ch4 = { 0x18, 0x1C, 0x16, 0x53, 0x7F, 0x7F, 0x50, 0x00 };
ch5 = { 0x27, 0x67, 0x45, 0x45, 0x7D, 0x39, 0x00, 0x00 };
ch6 = { 0x3C, 0x7E, 0x4B, 0x49, 0x79, 0x30, 0x00, 0x00 };
ch7 = { 0x03, 0x03, 0x71, 0x79, 0x0F, 0x07, 0x00, 0x00 };
ch8 = { 0x36, 0x7F, 0x49, 0x49, 0x7F, 0x36, 0x00, 0x00 };
ch9 = { 0x06, 0x4F, 0x49, 0x69, 0x3F, 0x1E, 0x00, 0x00 };

chars = {ch0, ch1, ch2, ch3, ch4, ch5, ch6, ch7, ch8, ch9};

function sendByte(reg, data)
  spi.send(1,reg * 256 + data)
  tmr.delay(50)
end

function displayChar(charIndex)
  local char = chars[charIndex + 1];
  -- iterates over all 8 columns and sets their values
  for i=1,8 do
    sendByte(i,char[i]);
  end
end

function setup_MAX7219()
    spi.setup(1, spi.MASTER, spi.CPOL_LOW, spi.CPHA_LOW, 16, 8)

    sendByte (MAX7219_REG_SHUTDOWN, 1)
    sendByte (MAX7219_REG_SCANLIMIT, 7)
    sendByte (MAX7219_REG_DECODEMODE, 0x00)
    sendByte (MAX7219_REG_DISPLAYTEST, 0)
    sendByte (MAX7219_REG_INTENSITY, 2)
    sendByte (MAX7219_REG_SHUTDOWN, 1)
    
    tmr.stop(0);
end

function setup_ds18b20()
   t = require("ds18b20")
   gpio0 = 4
   t.setup(gpio0)
   addrs = t.addrs()
end
-- changes the face every two seconds cycling through the array of faces
function start()
  show_temp()
  tmr.alarm(1, 1000, 0, function()
    start();
  end);
end

setup_MAX7219()
setup_ds18b20()

function show_temp()
  temp=t.read(addrs[1])/10000
  s=string.format("%02.4f",temp)
  print("Temperature 1: "..s.."'C")

  temp2 = temp
  array = {}
  i=0
  while (temp > 1) do
    show = math.floor(temp % 10)
    array[i] = show
    i = i + 1
--    displayChar(show)
    temp = temp / 10
--    print("digit = "..show.." "..i)
  end

  for j=i - 1, 0,-1 do
    print("j = "..j)
    displayChar(array[j])

--  while (temp > 1) do
--    show = math.floor(temp % 10)
--    displayChar(show)
--    temp = temp / 10
--    print("digit = "..show)
--
    for i=1,80000 do
      i=1;
    end
  end
end

start()


  
