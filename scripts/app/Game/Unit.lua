local Unit = class("Unit", function()
    return display.newScene("Unit")
end)

function Unit:ctor()
    self._listAttackMe = {} 	----------攻击自己的单位列表
    self._goal = nil 			----------攻击的目标
    self._AIN = GameData.fps 			---------攻击间隔
end

--传入的参数分别为：单位参数，初始化状态，出现位置，所属阵营
function Unit:init( node,state,pos,camp )
	self._img = display.newSprite(node.name)
	self._scale = node.scale
	self:setScale(self._scale)
	self._r = node.radius
    self:setAnchorPoint(ccp(0,0))
    self:addChild(self._img)

    self:setPosition(pos)
    self._camp = camp ----------所属阵营
	self._alertTime = node.alertTime ----------巡逻时间
	self._alertSpeed = node.alertSpeed ----------巡逻速度
	self._speed = node.speed  ----------移动速度
	self._speedX = node.speed ----------X方向速度
	self._speedY = node.speed ---------Y方向速度
	self._price = node.price ----------价格
	self._life = node.life ----------生命值
	self._ATK = node.ATK  ----------攻击力
	self._DEF = node.DEF  ----------防御力
	self._SD = node.SD    ----------射程
	self._ASP = node.ASP    ----------攻速
    self._cmd = state ----------单位接到的命令
    self:setState(state)

    self._lifeLabel = cc.ui.UILabel.new({text = "", size = 50}) 					----------显示生命值
    				:align(display.CENTER, 0, -self._r-40)
    				:addTo(self)
    self._lifeLabel:setString(self._life)

end

function Unit:setState( state )
	self._state = state
	if state == State.attack then
		self:toAttack()
	elseif state == State.alert then
		self:toAlert()
	elseif state == State.null then
		self:toDeath()
	end
end

function Unit:update()
    self._lifeLabel:setString(self._life)
    if self._state == State.null then 											----------消失
    	return true
	elseif self._state == State.attack then 									---------进攻
	 	moveCCnode(self, self._speedX, self._speedY)							---------向城堡移动
		if not hitR2P(GameData.rectScreen, self:getPositionInCCPoint()) then	---------到达边界
			self:setState(State.null)
		end
		self:searchEnemy() 														---------寻找攻击目标
	elseif self._state == State.alert then 										---------巡逻
		self._alertTime = self._alertTime - 1
		if self._alertTime <= 0 then
			self:toAlert()
		end
		moveCCnode(self, self._alertSpeed, -self._alertSpeed)	
		self:searchEnemy() 														---------寻找攻击目标
	elseif self._state == State.fight then 										---------攻击
		--updateGoal(self._goal)
		self:updateGoal()
	end
end

-- function Unit:_move(x,y)
-- 	self._movedistance =0
-- 	local curpos = self:getPositionInCCPoint()
-- 	self._speedX,self._speedY,self._distance = getSpeedXY(curpos,ccp(x,y),GameUnit.speed)
-- 	local angle = getAngle(curpos,ccp(x, y),_distance)
-- 	self:setRotation(-angle)
-- 	self:setState(State.move)
-- end


function Unit:searchEnemy() 													---------搜索敌人
	for i,enemy in ipairs(self._camp.enemyUnit) do
		if enemy._state ~= State.null then
			local distance = getDistance(self,enemy)
	   		local distance1 = self._r+enemy._r+self._SD
	    	if(distance<=distance1)then
	        	self:setState(State.fight)
	        	table.insert(enemy._listAttackMe,self)
	        	self._goal = enemy 
	        	return true
	    	end
		end
	end
	fort = self._camp.enemyFort
	local distance = getDistance(self,fort)
	local attackRange = self._r + fort._r + self._SD
	if distance <= attackRange then
		self:setState(State.fight)
		table.insert(fort._listAttackMe, self)
		self._goal = fort
		return true
	end
	return false
end

function Unit:toBurst()
	local function callback()
		self:setState(State.null)
	end
    local seq = transition.sequence({
        CCScaleTo:create(0.5, 0)
        , CCCallFunc:create(callback)
        })
    self:runAction(seq)
end

function Unit:toAttack() 														----------向敌方城堡进攻
	local curpos = self:getPositionInCCPoint()
	local topos = self._camp.enemyFort:getPositionInCCPoint()
	local distance
	self._speedX,self._speedY,distance = getSpeedXY(curpos,topos,self._speed)
	-- local angle = getAngle(curpos,ccp(display.width, display.height),distance)
	-- self._img:setRotation(-angle)
end

function Unit:toAlert(  ) 														----------巡逻
	self._alertSpeed = -self._alertSpeed
  	self._alertTime = GameUnit.alertTime 
	local curpos = self:getPositionInCCPoint()
	-- local angle = getAngle(curpos,ccp(curpos.x-self._alertSpeed, curpos.y+self._alertSpeed),math.abs(self._alertSpeed*math.sqrt(2)))
	-- self._img:setRotation(angle-90)
	if self._alertSpeed < 0 then
		self._img:setScaleX(2*self._camp.name-3)
	else
		self._img:setScaleX(3-2*self._camp.name)
	end
end

function Unit:toDeath( ) 														----------死亡
	self:updateAttackMe() ----------更新敌人
end

function Unit:updateGoal( ) 													----------攻击目标
	if self._goal._state ~= State.null then
		self._AIN = self._AIN - self._ASP
		if self._AIN <= 0 then
			if self._ATK > self._goal._DEF then 		----------扣除目标生命值
				self._goal._life = self._goal._life - (self._ATK-self._goal._DEF)
			end
			if self._goal._life <= 0 then 				----------目标生命值为零
				self._goal:setState(State.null) --消灭敌人
				self._camp.fort._gold = self._camp.fort._gold + self._goal._price/2 --获得金钱
			end
			self._AIN = GameData.fps
		end
	end
end

function Unit:updateAttackMe() 													----------更新敌人
	if(self._listAttackMe ~= {})then
		local i = 1
        local count = #self._listAttackMe
        while i <= count do
	        local obj = self._listAttackMe[i]
	        if obj._state == State.fight then
	            obj:setState(obj._cmd)
	        end
            i = i + 1
    	end
	end
end

return Unit