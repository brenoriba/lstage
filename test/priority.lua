local lstage=require'lstage'

local stage3=lstage.stage(
	function(name) 
		local index = 0
		for ix=0, 10000000 do
			index = index + 1
		end
		print(name)		
	end,2)

local stage2=lstage.stage(
	function(name) 
		local index = 0
		for ix=0, 10000000 do
			index = index + 1
		end
		print(name) 
		stage3:push('s3')
	end,2)

local stage1=lstage.stage(
	function(name) 
		local index = 0
		for ix=0, 10000000 do
			index = index + 1
		end
		print(name)
		stage2:push('s2')
	end,2)

--stage1:enablepriorityevent();

stage1:setpriority(1)
stage2:setpriority(2)
stage3:setpriority(3)

--stage1:steal(stage2,2);

new_priority=function()
	print("Fired!")
end

lstage.pool:add(1)

for i=1,8 do
   stage1:push('s1')
end

lstage.channel():get() 
