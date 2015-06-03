local GameDirector = class("GameDirector")
ClassFort = require("app.Game.Fort")
ClassUnit = require("app.Game.Unit")
ClassAddButton = require("app.Game.AddButton")

function GameDirector:ctor()
	self._AddUnitTime = GameUnit.addTime
	self._onTouch = GameTouch.null 	----------点击的控件名称
end

function GameDirector:init(scene)
	self:initFort(scene)
	self:addFort(GameFort1)
	self:addFort(GameFort2)

	self:initUnit(scene)
	self:initUnit2(scene)	

	self:initAddButton(scene)	
	self:addAddButton(GameTank1, GameTouch.addUnitAlert, ccp(128, 28))
	self:addAddButton(GameTank1,GameTouch.addUnitAttack,ccp(168, 28))

	self:addAddButton(GameTank3, GameTouch.addUnitAlert, ccp(208, 28))	
	self:addAddButton(GameTank3,GameTouch.addUnitAttack,ccp(248, 28))	

	self:distributeCamp( )	 													----------分配阵营
end

function GameDirector:update()
	self:addUnit2OnTime()
	updateObjectList(self._listFort)
	updateObjectList(self._listUnit)
	updateObjectList(self._listUnit2)
end

function GameDirector:onTouch( name,x,y,prevX,prevY )
	if name == TouchEventString.began then 
		if self:touchAddButton(name, x, y, prevX, prevY) then 					----------点击添加单位

		elseif self._listFort[1]:onTouch(name, x, y, prevX, prevY) then 		----------点击我方城堡
			self._onTouch = GameTouch.fort1
		
		elseif 	self._listFort[2]:onTouch(name, x, y, prevX, prevY) then 		----------点击敌方城堡
			self._onTouch = GameTouch.fort2
		
		elseif self._onTouch == GameTouch.addUnitAttack then 					----------增加进攻单位
			if self._listFort[1]._gold >= self._addNode.price then
	        	self:addUnit(self._addNode,State.attack,ccp(x, y))
	        	self._listFort[1]._gold = self._listFort[1]._gold - self._addNode.price
			end
		elseif self._onTouch == GameTouch.addUnitAlert then 					----------增加巡逻单位
	        if self._listFort[1]._gold >= self._addNode.price then
	        	self:addUnit(self._addNode,State.alert,ccp(x, y))	
	        	self._listFort[1]._gold = self._listFort[1]._gold - self._addNode.price
	        end        
	    -- elseif g_director._listAlert[1]._clicked then
	    --     g_director:checkUnit(x,y)
		end
	end	
end

function GameDirector:initFort( scene ) 										----------城堡
	self._listFort = {}
	self._layerFort = display.newNode()
	scene:addChild(self._layerFort)
end

function GameDirector:addFort(node)
    local Fort = ClassFort.new()
    Fort:init(node)
    table.insert(self._listFort, Fort)
    self._layerFort:addChild(Fort)
end

function GameDirector:initAddButton( scene ) 										----------添加按钮
	self._listAddButton = {}
	self._layerAddButton = display.newNode()
	scene:addChild(self._layerAddButton)
end

function GameDirector:addAddButton(name,cmd,pos)
    local AddButton = ClassAddButton.new()
    AddButton:init(name,cmd,pos)
    table.insert(self._listAddButton, AddButton)
    self._layerAddButton:addChild(AddButton)
end

function GameDirector:touchAddButton(name, x, y, prevX, prevY)
	for i,addButton in ipairs(self._listAddButton) do
		if addButton:onTouch(name, x, y, prevX, prevY) then
			self._onTouch = addButton._cmd 											----------添加单位所接受的命令
			self._addNode = addButton._node 										----------添加单位的名称
			return true
		end
	end
end

function GameDirector:initUnit( scene ) 											---------我方单位
	self._listUnit = {}
	self._layerUnit = display.newNode()
	scene:addChild(self._layerUnit)
end

function GameDirector:addUnit(name,state,pos)
    local Unit = ClassUnit.new()
    Unit:init(name,state,pos,self._camp1)
    table.insert(self._listUnit, Unit)
    self._layerUnit:addChild(Unit)
end

function GameDirector:initUnit2( scene ) 										----------敌方单位
	self._listUnit2 = {}
	self._layerUnit2 = display.newNode()
	scene:addChild(self._layerUnit2)
end

function GameDirector:addUnit2(node,state,pos)
    local Unit2 = ClassUnit.new()
    Unit2:init(node,state,pos,self._camp2)
    table.insert(self._listUnit2, Unit2)
    self._layerUnit2:addChild(Unit2)
end

function GameDirector:distributeCamp(  ) 										----------分配阵营
	self._camp1 = {} ----------我方阵营
	self._camp1.name = 1
	self._camp1.fort = self._listFort[1] --我方城堡
	self._camp1.enemyFort = self._listFort[2] --敌方城堡
	self._camp1.unit = self._listUnit --我方单位
	self._camp1.enemyUnit = self._listUnit2 --敌方单位

	self._camp2 = {} ----------敌方阵营
	self._camp2.name = 2
	self._camp2.fort = self._listFort[2] --我方城堡
	self._camp2.enemyFort = self._listFort[1] --敌方城堡
	self._camp2.unit = self._listUnit2 --我方单位
	self._camp2.enemyUnit = self._listUnit --敌方单位
end

function GameDirector:addUnit2OnTime(  ) 										----------按时间增加敌人
	if self._AddUnitTime > 0 then
		self._AddUnitTime = self._AddUnitTime - 1 								
	elseif self._AddUnitTime <= 0 and #self._listUnit2 < GameUnit.maxNum then
		if self._listFort[2]._gold >= GameTank2.price then
			local x = math.random(GameData.rectScreen.right*2/3,GameData.rectScreen.right*4/5)
			local y = math.random(GameData.rectScreen.top*2/3,GameData.rectScreen.top*4/5)
			local state = math.random(State.attack,State.alert)
			self._AddUnitTime = GameUnit.addTime
			self:addUnit2(GameTank2,state,ccp(x, y))
			self._listFort[2]._gold = self._listFort[2]._gold - GameTank2.price
		end
	end
end



-- function GameDirector:checkUnit(x,y)
--      --updateObjectList(self._listUnit)
--     local i = 1
--     local count = #self._listUnit
--      while i <= count do
--        local obj = self._listUnit[i]

--         --obj:moveTo(4,x,y)
--         obj:_move(x,y)
--        --print(i)
--         i = i+1
--    end
   
-- end



return GameDirector