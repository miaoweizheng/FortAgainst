local Unit2 = class("Unit2", function()
    return display.newScene("Unit2")
end)

function Unit2:ctor()
    self._listAttackMe = {} 	----------攻击自己的单位列表
    self._goal = nil 			----------攻击的目标
end

function Unit2:init( node,state,pos )
	self._img = display.newSprite(node.name)
	self._scale=node.scale
	self:setScale(self._scale)
	self._r=node.radius
    self:setAnchorPoint(ccp(0,0))
    self:addChild(self._img)

	self._alertTime = node.alertTime ----------巡逻时间
	self._alertSpeed = node.alertSpeed ----------巡逻速度
	self._speed = node.speed  ----------移动速度
	self._speedX = node.speed ----------X方向速度
	self._speedY = node.speed ---------Y方向速度
	self._life = node.life ----------生命值
	self:setPosition(pos)
	self._cmd = state ----------单位接到的命令
	self:setState(state)

	self._label = cc.ui.UILabel.new({text = "", size = 50}) 					-----------生命值标签
    :align(display.CENTER, 0, -self._r-40)
    :addTo(self)
    self._label:setString(self._life)
end

function Unit2:setState( state )
	self._state = state
	if state == State.attack then
		self:toAttack()
	elseif state == State.alert then
		self:toAlert()
	elseif state == State.burst then
		self:toBurst()
	end
end

function Unit2:update()
    self._label:setString(self._life)
    if self._state == State.null then 											----------消失
		return true
	elseif self._state == State.attack then 									---------进攻
		moveCCnode(self,self._speedX,self._speedY) 								----------向城堡移动
		if not hitR2P(GameData.rectScreen, self:getPositionInCCPoint()) then	----------到达边界
			self:setState(State.null)
		end
		self:hitUnit2() 														---------寻找攻击目标
	elseif self._state == State.alert then 										---------巡逻
		self._alertTime = self._alertTime - 1
		if self._alertTime < 0 then
			self:toAlert()
		end
		moveCCnode(self, self._alertSpeed, -self._alertSpeed)
		self:hitUnit2() 														---------寻找攻击目标
	elseif self._state == State.fight then 										---------攻击
		self:updateEnemy()
	end
end

function Unit2:hitUnit2()----
	for i,unit2 in ipairs(g_director._listUnit) do
		if unit2._state ~= State.null then
			local distance = getDistance(self,unit2)
	   		local distance1 = self._r+unit2._r+50
	    	if(distance<=distance1)then
	        	self:setState(State.fight)
	        	table.insert(unit2._listAttackMe,self)
	        	self._goal = unit2 
	        	return true
	    	end
		end
	end
	return false
end

function Unit2:toBurst()
	local function callback()
		self:setState(State.null)
	end
    local seq = transition.sequence({
        CCScaleTo:create(0.5, 0)
        , CCCallFunc:create(callback)
        })
    self:runAction(seq)
end

function Unit2:toAttack(  )
	local curPos = self:getPositionInCCPoint()
	local distance
	self._speedX,self._speedY,distance = getSpeedXY(curPos,ccp(0, 0),self._speed)
	-- local angle = getAngle(curPos,ccp(0, 0),distance)
	-- self._img:setRotation(180-angle)
end

function Unit2:toAlert(  )
	self._alertSpeed = -self._alertSpeed
  	self._alertTime = GameUnit.alertTime 
	local curpos = self:getPositionInCCPoint()
	-- local angle = getAngle(curpos,ccp(curpos.x-self._alertSpeed, curpos.y+self._alertSpeed),math.abs(self._alertSpeed*math.sqrt(2)))
	-- self._img:setRotation(angle+90)
	if self._alertSpeed < 0 then
		self._img:setScaleX(1)
	else
		self._img:setScaleX(-1)
	end
end

function Unit2:updateEnemy(  )
	if self._goal._state ~= State.null then
		self._goal._life = self._goal._life - 1
		if self._goal._life <= 0 then
			self._goal:updateAttackMe()
			self._goal:setState(State.null)
		end
	end
end

function Unit2:updateAttackMe()
	if(self._listAttackMe ~= {})then
		local i = 1
        local count = #self._listAttackMe
        while i <= count do
	        local obj = self._listAttackMe[i]
	        if (obj._state == State.fight)then
	            obj:setState(obj._cmd)
	        end
	            i = i + 1
    	end
	end
end

return Unit2