local Alert = class("Alert", function()
    return display.newScene("Alert")
end)

function Alert:ctor()
	self._imgAlert = display.newSprite("tank1.png")
	self._r=GameAlert.radius
	self._scale=GameAlert.scale
	self:setScale(self._scale)
    self:setAnchorPoint(ccp(0,0))
    self:addChild(self._imgAlert)

    self._clicked = false
    self:setState(State.null)
end

function Alert:init( pos )
	self:setPosition(pos)
end

function Alert:setState( state )
	self._state = state
end

function Alert:update()
	
end

function Alert:onTouch(name,x,y,prevX,prevY)
	if getDistanceN2P(self, ccp(x, y))<self._r then
		if name == TouchEventString.began then
	        click(self)
	        self._clicked = not self._clicked
		elseif name == TouchEventString.ended then
	        
		end
		return true	
	else 
		return false
	end
end



return Alert