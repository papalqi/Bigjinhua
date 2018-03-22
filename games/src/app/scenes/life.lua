local Life = class("Life", function(name)
	local image = name..".png"
	local LifeSprite=display.newSprite(image)
	local size=LifeSprite:getContentSize()
	local speed=5
	return LifeSprite 
	
end)
function Life:ctor()
	Development="Development"
	Attack="Attack"
	Escape="Escape"
	state_now="Development"
	self.state={}
	self.state.safe_f=10
	self.rad=1
	self:Init_State_function()
end

--MOVE动作函数，参数是角度
function Life:Move( dir)
	-- body
	local life_move=cc.MoveTo:create(time,cc.p(to_position_x,to_position_y))
	return life_move
end
--内部调用MOVE函数
function Life:GetMoveAction( time,to_position_x,to_position_y)
	-- body
	local life_move=cc.MoveBy:create(time,cc.p(to_position_x,to_position_y))
	return life_move
end
function Life:Change_scal(sc)--改变玩家大小
	self.rad=sc+self.rad
	self:scale(self.rad)

end
function Life:Get_Rad()--获得生命的半径值
	return self.rad
end


--------------------------------------------
function Life:AI_Action(emery,id)
	self:State_Jundge(emery,id)
	return self.state.Development()
end
function Life:Init_State_function()
	self.state[Development]=function()--发育函数
		local e_x =  10*math.round(math.random(-10,10) )
    	local e_y = 10*math.round(math.random(-10,10) )
    	return self:Straight_Action(e_x,e_y)
	end
	self.state[Attack]=function()--攻击函数
	end
	self.state[Escape]=function()--逃跑函数
	end
end
function Life:State_Jundge(emery,id)--判断是哪个状态
		local dis=0
		for i,em in pairs(emery) do
			if i~=id then--判断和其他所有人除了自己
				local dis=self:get_distance(em:getPositionX(),em:getPositionY())--获取获取和敌人的距离
				if dis<self.state.safe_f and self:Get_Rad()<em:Get_Rad() then
					state_now=Escape
				elseif dis<self.state.safe_f and self:Get_Rad()>em:Get_Rad()  then
						state_now=Attack
					else state_now=Development						
				end
			end
		end
end
function Life:get_distance(em_x,em_y)
	-- body
	local dis=cc.pGetDistance(cc.p(self:getPositionX(),self:getPositionY()),cc.p(em_x,em_y))--获取和敌人的距离
	return dis
end
function Life:Straight_Action(to_x,to_y)
	local life_move=cc.MoveBy:create(2,cc.p(to_x,to_y))
	return life_move
end
function Life:Turn_Action()

end


-----------------------------------
return Life