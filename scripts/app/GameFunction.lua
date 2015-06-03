math.randomseed(os.time())

function getRandomInt(s,e)
    return math.random(s,e)
end

function getRandomFloat(s,e)
    return math.random()*(e-s)+s
end

function sin(angle)
    return math.sin(math.rad(angle))
end

function cos(angle)
    return math.cos(math.rad(angle))
end

function arcSin(sinValue,x)
    if x and x >= 0 then
        return math.deg(math.asin(sinValue))
    else
        return -math.deg(math.asin(sinValue)) + 180
    end
end

function arcCos(cosValue,y)
    if y and y >=0 then
        return math.deg(math.acos(cosValue))
    else
        return -math.deg(math.acos(cosValue))
    end
end

function addName( name )
    
end

function getAngle(fromPos,toPos,distance) -----------角度
    local detX = toPos.x - fromPos.x
    local detY = toPos.y - fromPos.y    
    if not distance then
        distance = math.sqrt(detX * detX + detY * detY)
    end
    local sinValue = detY/distance
    return arcSin(sinValue,detX)
end

function getDistanceN2P(node1,pos) ---------单位与坐标的间距
    local detX = node1:getPositionX() - pos.x
    local detY = node1:getPositionY() - pos.y
    local distance = math.sqrt(detX * detX + detY * detY)
    return distance
end

function hitR2P(rect,pos) ----------越界
    if pos.x >= rect.left and pos.x <= rect.right and pos.y >= rect.bottom and pos.y <= rect.top then
        return true
    end
    return false
end

function getDistance(node1,node2) ----------单位与单位之间的距离 
    local detX = node1:getPositionX() - node2:getPositionX()
    local detY = node1:getPositionY() - node2:getPositionY()
    local distance = math.sqrt(detX * detX + detY * detY)
    return distance
end

function getDistanceParams(fromPos,toPos) ----------移动的角度和距离
    local detX = toPos.x - fromPos.x
    local detY = toPos.y - fromPos.y
    local distance = math.sqrt(detX * detX + detY * detY)
    if distance == 0 then
        return 0,1,0
    end
    local sinValue = detY/distance
    local cosValue = detX/distance
    return sinValue,cosValue,distance
end

function getSpeedXY(fromPos,toPos,speed) -----------移动的速度和距离
    local sin,cos,distance = getDistanceParams(fromPos,toPos)
    local spdX = speed * cos
    local spdY = speed * sin
    return spdX,spdY,distance
end


function getDisplayLB( unit ) ----------屏幕左下角坐标
    return ccp(unit.radius, unit.radius)
end

function getDisplayLT( unit ) ----------屏幕左上角坐标
    return ccp(unit.radius, CONFIG_SCREEN_HEIGHT-unit.radius)
end

function getDisplayRT( unit ) ----------屏幕右上角坐标
    return ccp(CONFIG_SCREEN_WIDTH-unit.radius, CONFIG_SCREEN_HEIGHT-unit.radius)
end

function click( node ) ----------点击动作
    local seq = transition.sequence({
    CCScaleTo:create(1/25, node._scale*0.8), 
    CCScaleTo:create(1/25,node._scale)
    })
    node:runAction(seq)
end

function moveCCnode(ccnode,x,y) ----------移动
    local pos = ccnode:getPositionInCCPoint()
    pos.x = pos.x + x
    pos.y = pos.y + y
    ccnode:setPosition(pos)
    return pos
end

function updateObjectList(list) ----------更新单位
    local i = 1
    local count = #list
    while i <= count do
        local obj = list[i]
        if obj:update() then
            table.remove(list,i)
            obj:removeSelf()
            count = count - 1
        else
            i = i + 1
        end
    end
    return count
end

function updateObjectListState(list,state) ----------更新状态
    local i = 1
    local count = #list
    while i <= count do
        local obj = list[i]
        obj:setState(state)
        i = i + 1
    end
    return count
end

-- function updateGoal( node ) ----------更新目标单位
--     if node._state ~= State.null then
--         node._life = node._life - 1
--         if node._life <= 0 then
--             updateAttackMe(node)
--             node:setState(State.null)
--         end
--     end
-- end

-- function updateAttackMe( node ) ----------更新攻击单位列表
--     if(node._listAttackMe ~= {})then
--         local i = 1
--         local count = #node._listAttackMe
--         while i <= count do
--             local obj = node._listAttackMe[i]
--             if obj._state == State.fight then
--                 obj:setState(obj._cmd)
--             end
--             i = i + 1
--         end
--     end
-- end