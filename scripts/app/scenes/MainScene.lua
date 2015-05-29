require("app.GameFunction")
require("app.GameData")
ClassGameDirectort = require("app.Game.GameDirector")

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    self:initControl()
    self:initBack()
    g_director = ClassGameDirectort.new()
    g_director:init(self)
    self:initUpdate()
end

function MainScene:initControl()
    local layer = display.newLayer() ----------鼠标点击控件
    layer:setTouchEnabled(true)
    layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, 
        function(event)
            return self:onTouch(event.name, event.x, event.y, event.prevX, event.prevY)
        end
        )
    layer:setTouchSwallowEnabled(false)
    self:addChild(layer)
end

function MainScene:initBack()
    local imgBack = display.newSprite("back3.jpg")
    imgBack:setAnchorPoint(ccp(0,0))
    self:addChild(imgBack) 
end

function MainScene:initUpdate()
    self._scheduler = require("framework.scheduler")
    self._scheduler.scheduleGlobal(handler(self, self.update), 1/GameData.fps)
end

function MainScene:update()
    g_director:update()
end

function MainScene:onTouch(name,x,y,prevX,prevY)
    if not g_director:onTouch(name, x, y, prevX, prevY) then
        
    end
    
	return true
end

return MainScene
