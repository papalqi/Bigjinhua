Life=import("app.scenes.Life")
DouDou=import("app.scenes.DouDou")
local PlayScene = class("PlayScene", function()
    return display.newScene("PlayScene")
end)

function PlayScene:ctor()
	jishuqi=0--移动相关的计数器
  jishuqi2=0--生成豆豆的计数器
  R_beishu=0.1--半径增加参数
  ID_jishu=0--每个豆豆ID相关的计数器
  self.shiwu={}
  self.emery={}
	self:UI_Init_All()
  local camera=cc.Camera:createOrthographic(display.width,display.height,0,1)
  camera:setCameraFlag(cc.CameraFlag.USER1)
  layer0:addChild(camera)
  layer0:setCameraMask(2)
  self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT,function(dt)
      jishuqi2=jishuqi2+1
    if jishuqi2==2000 then
      self:UI_DouDou_Init(layer0)
      jishuqi2=0
    end
     self:camera_and_Listener()
    camera:setPositionX(life_user:getPositionX()-display.cx)
    camera:setPositionY(life_user:getPositionY()-display.cy)
    for id,z in pairs(self.shiwu)do
      if z:jianshi(life_user:getPositionX(),life_user:getPositionY(),10*(life_user:Get_Rad()))==true then
         print("···")
        z:removeFromParent()
        self.shiwu[id]=nil
        life_user:Change_scal(R_beishu)--改变玩家大小
      end
    end
    end)
  self:scheduleUpdate()
end

function PlayScene:camera_and_Listener()
   for i,em in pairs(self.emery)do--AI操作
    em:runAction(em:AI_Action(self.emery,i))
   end
end

---------------------------------------------------------------------------
function PlayScene:UI_DouDou_Init(layer)--初始化食物
  for x =-30,29 do
    for y=-15,15 do
        self:Rom_Init_doudou(x,y,layer) 
    end
  end
end
function PlayScene:Rom_Init_doudou(N_X,N_Y,layer)
  -- body
 
  local r_x =  math.round(math.random(N_X*100,N_X*100+100) )
  local r_y = math.round(math.random(N_Y*100,N_Y*100+100) )
  if math.round(math.random(10,20) )>10 then


     local a=DouDou.new("xingxing",ID_jishu) 
      :pos(r_x,r_y)
      :addTo(layer0)
      :scale(0.2)
      a:setCameraMask(2)
      self.shiwu[ID_jishu]=a
      ID_jishu=ID_jishu+1
  end
end

function PlayScene:UI_Init_All()
  -- body
  local r = display.cy/3
  local size = display.height/12
  layer0=display.newLayer()--创建第0层
  layer0:addTo(self)
  layer0:zorder(1)
  display.newSprite("background.png")
   :pos(display.cx,display.cy)
   :addTo(layer0)
   :scale(5)
  self:UI_DouDou_Init(layer0)--初始化豆豆
  life_user=self:SetNewUserLife("qiu",display.cx, display.cy,layer0)--创建本机玩家，添加到第0层
  self:UI_Init_Emeny()--初始化敌人
  layer1=display.newLayer()--创建第一层
  layer1:addTo(self)
  layer1:zorder(2)
  self:UI_Init_chupeng(layer1)--创建触碰界面层
end
--控制生命移动

function PlayScene:UI_Init_chupeng( layer )
  -- body
  local layer2=layer
  local rid=nil
  layer2:setTouchEnabled(true)
  layer2:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE)
  layer2:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
       for id,point in pairs(event.points)do
            if(event.name=="began")then
              --摇杆区域
              rid=id
              location_x=point.x
              location_y=point.y
              self:UI_circle(layer2,location_x,location_y) 
                return true
          elseif(event.name=="moved")then
            for sid,spoint in pairs(event.points)do
                if (2>1)then
                if(sid==rid)then
                
                    local  dis=cc.pGetDistance(cc.p(location_x,location_y),cc.p(spoint.x,spoint.y))
                    local  rat=50/dis
                    local Px=rat*(spoint.x-location_x)
                    local Py=rat*(spoint.y-location_y)
                    circle:setPosition(Px+location_x,Py+location_y)
                    byo_point_x=rat*(spoint.x-location_x)
                    byo_point_y=rat*(spoint.y-location_y)
                   
                    if(life_user:getPositionX()>3000 and byo_point_x>0)then
                      byo_point_x=0
                    end
                    if(life_user:getPositionX()<-3000 and byo_point_x<0)then
                      byo_point_x=0
                    end
                    if(life_user:getPositionY()>1500 and byo_point_y>0)then
                      byo_point_y=0
                    end
                    if(life_user:getPositionY()<-1500 and byo_point_y<0)then
                      byo_point_y=0
                    end
                    self:Life_move(1,byo_point_x,byo_point_y)
                  end       
                end
              end
        elseif(event.name=="ended")then
          dir:removeFromParent()
          circle:removeFromParent()
          life_user:stopAllActions()
          self:life_move_guanxing(5,byo_point_x*50,byo_point_y*50)     
        end
      end 
   
    end )--初始化触碰层
end
function PlayScene:UI_circle(layer,location_x,location_y)
	local r = display.cy/3
	local size = display.height/12
	 dir=display.newSprite("circle.png")
   	dir:setOpacity(150)
   	local size1=dir:getContentSize()
	local size2 = display.height/3
	dir:setPosition(cc.p(location_x,location_y))
	dir:setScale(size2/(dir:getContentSize().width), size2/(dir:getContentSize().height))
    circle=display.newSprite("dir.png")
    circle:setOpacity(200)
	circle:setPosition(cc.p(location_x,location_y))
	circle:setScale(size /(circle:getContentSize().width), size/(circle:getContentSize().height))
	layer:add(dir,2)
	layer:add(circle,2)	
end
function PlayScene:UI_Init_Emeny()
  for i=1,40 do
    self:UI_Init_Emeny_one(i)
  end
end
function PlayScene:UI_Init_Emeny_one(id)
    local e_x =  math.round(math.random(-3000,3000) )
    local e_y = math.round(math.random(-1500,1500) )
   local life_emery=self:SetNewUserLife("qiu",e_x, e_y,layer0)--创建敌方玩家，添加到第0层
   self.emery[id]=life_emery

end

-----------------------------------------------------------
function PlayScene:Life_move(time,byo_point_x,byo_point_y)
  if(jishuqi==5)then

   life_action=life_user:GetMoveAction(time,byo_point_x/5,byo_point_y/5)
      life_user:runAction(life_action)
      jishuqi=0
  end
  jishuqi=jishuqi+1
end

function PlayScene:life_move_guanxing(time,byo_point_x,byo_point_y)
   life_action=life_user:GetMoveAction(time,byo_point_x/5,byo_point_y/5)
      life_user:runAction(life_action)
      jishuqi=0
end
-----------------------------------------------------------------------------
--创建一个玩家
--外部调用函数
function PlayScene:SetNewUserLife(name,x,y,layer)
	-- body
	local life=self:NewUserLife(name)
	:pos(x,y)
  :addTo(layer)
  return life
end
--生成新的生命内部函数
function PlayScene:NewUserLife( name )
	-- body
	local life =Life.new(name)
	return life 
end
-----------------------------------------------------------------
function PlayScene:onEnter()
end

function PlayScene:onExit()
end

return PlayScene
