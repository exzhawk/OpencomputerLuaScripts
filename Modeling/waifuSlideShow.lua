--
-- User: Epix
-- Date: 2017/2/1
-- Time: 23:17
--

-- simple slide viewer. support multi screen
-- need to copy & paste ctif code or require it to acquire `loadImage` and `drawImage` method
-- ctif: https://oc.cil.li/index.php?/topic/864-chenthread-image-format-high-quality-images-on-opencomputers/
local fs = require('filesystem')
local component = require('component')
local gpu = component.gpu

-- waifu pic folder
local folder_path = '/waifu/pic/'

function getScreens()
    local screens = {}
    for addr, _ in pairs(component.list('screen')) do
        table.insert(screens, addr)
    end
    return screens
end

function getFiles()
    local pic_list = {}
    for filename in fs.list(folder_path) do
        table.insert(pic_list, folder_path .. filename)
    end
    return pic_list
end

function run()
    local screens = getScreens()
    local files = getFiles()
    while 1 do
        for index, screen in ipairs(screens) do
            gpu.bind(screen)
            gpu.setResolution(160, 50)
            local image_filename = files[math.random(#files)]
            local image = loadImage(image_filename)
            drawImage(image)
        end
        os.sleep(30)
    end
end

run()