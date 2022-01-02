function love.conf(t) ---Engine method to set configuration of game
    t.identity = "go_game"
    t.appendidentity = false
    t.version = "11.3"
    t.console = true
    t.accelerometerjoystick = false
    t.externalstorage = false
    t.gammacorrect = false
  
    t.audio.mic = false
    t.audio.mixwithsystem = true
  
    t.window.title = "Go"
    t.window.icon = nil
    t.window.width = 2560   
    t.window.height = 1440
    t.window.borderless = false
    t.window.resizable = false
    t.window.minwidth = 1
    t.window.minheight = 1
    t.window.fullscreen = true
    t.window.fullscreentype = "desktop"
    t.window.vsync = 1
    t.window.msaa = 8
    t.window.depth = 16
    t.window.stencil = 8
    t.window.display = 1
    t.window.highdpi = true
    t.window.usedpiscale = true
    t.window.x = nil
    t.window.y = nil
  
    t.modules.audio = true
    t.modules.data = true
    t.modules.event = true
    t.modules.font = true
    t.modules.graphics = true
    t.modules.image = true
    t.modules.joystick = false
    t.modules.keyboard = true
    t.modules.math = true
    t.modules.mouse = true
    t.modules.physics = false
    t.modules.sound = true
    t.modules.system = true
    t.modules.thread = false
    t.modules.timer = true
    t.modules.touch = true
    t.modules.video = true
    t.modules.window = true
  end