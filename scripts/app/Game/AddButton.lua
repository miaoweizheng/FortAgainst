local AddButton = class("AddButton", function()
    return display.newScene("AddButton")
end)

function AddButton:ctor()
    -- self._clicked = false
end

--传入的参数分别为：单位信息，接受的命令，位置
function AddButton:init( node,cmd,pos )
	self._node = node
	self._cmd = cmd ----------命令

	self._imgAddButton = display.newSprite(node.name)
	self._r=GameAddButton.radius
	self._scale=GameAddButton.scale
	self:setScale(self._scale)
    self:setAnchorPoint(ccp(0,0))
    self:addChild(self._imgAddButton)

    local label = cc.ui.UILabel.new({text = "", size = 50}) 		----------显示命令
    			:align(display.CENTER, 0, -self._r)
    			:addTo(self)
    if cmd == GameTouch.addUnitAlert then
    	label:setString("巡逻")
    else
    	label:setString("进攻")
    end

	self:setPosition(pos)
end

function AddButton:setState( state )
	self._state = state
end

function AddButton:update()
	
end

function AddButton:onTouch(name,x,y,prevX,prevY)
	if getDistanceN2P(self, ccp(x, y))<self._r then
		if name == TouchEventString.began then
	        click(self)
	        -- self._clicked = not self._clicked
		elseif name == TouchEventString.ended then
	        
		end
		return true	
	else 
		return false
	end
end



return AddButton