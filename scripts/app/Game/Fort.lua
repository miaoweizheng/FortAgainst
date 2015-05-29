local Fort = class("Fort", function()
    return display.newScene("Fort")
end)

function Fort:ctor()
	local img = display.newSprite("fort4.png")
	self._scale=GameFort.scale
	self:setScale(self._scale)
	self._r=GameFort.radius
	self:setAnchorPoint(ccp(0,0))
	self:addChild(img)

	self:initControl()
	self:setState(State.null)

end

function Fort:init( pos )
	self:setPosition(pos)
    self._life = cc.ui.UILabel.new({text = "life", size = 24})
    :align(display.CENTER, 0, -self._r)
    :addTo(self)
end

function Fort:initControl()
    -- local layer = display.newLayer()
    -- layer:setTouchEnabled(true)
    -- layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, 
    --     function(event)
    --         return self:onTouch(event.name, event.x, event.y, event.prevX, event.prevY)
    --     end
    --     )
    -- layer:setTouchSwallowEnabled(false)
    -- self:addChild(layer)
end

function Fort:setState( state )
	self._state = state
end

function Fort:update()
	
end

function Fort:onTouch(name,x,y,prevX,prevY)
	if getDistanceN2P(self, ccp(x, y))<self._r then
		if name == TouchEventString.began then
	        click(self)
		elseif name == TouchEventString.ended then
	        
		end
		return true	
	else 
		return false
	end
end

return Fort