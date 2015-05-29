TouchEventString = TouchEventString or {} --------鼠标事件名称
TouchEventString.began = "began"
TouchEventString.moved = "moved"
TouchEventString.ended = "ended"
TouchEventString.canceled = "canceled"

State = State or {}	--------单位状态
State.null = 0
State.move = 1
State.burst = 3
State.attack = 4
State.alert = 5
State.fight = 6

GameTouch = GameTouch or {} ----------鼠标当前点击控件名称
GameTouch.null = 0
GameTouch.fort1 = 1
GameTouch.fort2 = 2
GameTouch.addUnitAlert = 3
GameTouch.addUnitAttack = 4
GameTouch.scene = 5


GameData = GameData or{} ----------游戏参数
GameData.fps = 50
GameData.rectScreen = {left = 25, right = CONFIG_SCREEN_WIDTH-25, top = CONFIG_SCREEN_HEIGHT-25, bottom = 25}
GameData.moveSpeed = 20

GameFort = GameFort or {} ----------城堡参数
GameFort.scale=0.5
GameFort.radius = 125*GameFort.scale

GameUnit = GameUnit or {} ----------作战单位参数
-- GameUnit.scale = 0.1
-- GameUnit.radius = 80*GameUnit.scale
GameUnit.maxNum = 5
GameUnit.speed = 3
GameUnit.alertTime = 20
GameUnit.addTime = 30
-- GameUnit.tank1 = "tank1.png"
-- GameUnit.tank2 = "tank2.png"
-- GameUnit.tank3 = "tank3-1.png"
-- GameUnit.bullet = "bullet.png"

GameTank1 = GameTank1 or {}
GameTank1.name = "tank1.png"
GameTank1.scale = 0.15
GameTank1.radius = 80*GameTank1.scale
GameTank1.speed = 3
GameTank1.alertSpeed = 1
GameTank1.life = 50

GameTank2 = GameTank2 or {}
GameTank2.name = "tank2.png"
GameTank2.scale = 0.15
GameTank2.radius = 80*GameTank2.scale
GameTank2.speed = 3
GameTank2.alertSpeed = 1
GameTank2.life = 50

GameTank3 = GameTank3 or {}
GameTank3.name = "tank3-1.png"
GameTank3.scale = 0.2
GameTank3.radius = 80*GameTank3.scale
GameTank3.speed = 3
GameTank3.alertSpeed = 1
GameTank3.life = 50

GameUnit2 = GameUnit2 or {} ----------作战单位参数
GameUnit2.scale = 0.1
GameUnit2.radius = 80*GameUnit2.scale
GameUnit2.alertTime = 20
GameUnit2.maxNum = 5
GameUnit2.speed = 2

GameAddButton = GameAddButton or {} ----------添加按钮
GameAddButton.scale = 0.3
GameAddButton.radius = 80*GameAddButton.scale