local DouDou = class("DouDou", function(name,ID)
	local image = name..".png"
	local DouDouSprite=display.newSprite(image)
	DouDouSprite.size=DouDouSprite:getContentSize()
	DouDouSprite.speed=5
	DouDouSprite.ID=ID
	return DouDouSprite 
	
end)
function DouDou:ctor()
	
end
function DouDou:jianshi(to_x,to_y,r)
	if to_x<(self:getPositionX()+r) and to_x>(self:getPositionX()-r) and to_y<(self:getPositionY()+r )and to_y>(self:getPositionY()-r )then
		print(true)		   
		return true
		else
		return false
	end
end

--MOVE动作函数，参数是角度
function DouDou:Move( dir)
	-- body
	local DouDou_move=cc.MoveTo:create(time,cc.p(to_position_x,to_position_y))
	return DouDou_move
end
--内部调用MOVE函数
function DouDou:GetMoveAction( time,to_position_x,to_position_y)
	-- body

	local DouDou_move=cc.MoveBy:create(time,cc.p(to_position_x,to_position_y))
	return DouDou_move
end
return DouDou