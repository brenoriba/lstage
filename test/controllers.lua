local lstage  = require 'lstage'
local srpt    = require 'lstage.controllers.srpt'
local mg1     = require 'lstage.controllers.mg1'
local dynamic = require 'lstage.controllers.dynamic'
local seda    = require 'lstage.controllers.seda'

-- Creating stages table
local policy = "DYNAMIC"
local stages = {}
local cores  = lstage.cpus()
local start  = lstage.now()

local stage3=lstage.stage(
	function() 
		local a = 0
		for variable = 0, 10000000 do
			a = a + 1
			local b = a
		end	
		print("[Tempo] "..lstage.now() - start)
	end,2)

local stage2=lstage.stage(
	function()
		local a = 0
		for variable = 0, 1000 do
			a = a + 1
			local b = a
		end	
		stage3:push()
	end,2)

local stage1=lstage.stage(
	function() 
		local a = 0
		for variable = 0, 100000 do
			a = a + 1
			local b = a
		end	
		stage2:push()
	end,2)


for i=1,100 do
	stage1:push()
	stage2:push()
	stage3:push()
end

-- =============================================
-- SRPT
-- =============================================
if (policy == "SRPT") then
	-- Stage 2
	stages[1] 	    = {}
	stages[1].stages    = {}
	stages[1].index     = 1
	stages[1].stages[1] = stage2

	-- Stage 1
	stages[2] 	    = {}
	stages[2].stages    = {}
	stages[2].index     = 0
	stages[2].stages[1] = stage1

	-- Configuring priority between stages
	srpt.configure(stages, cores, true)
end

-- =============================================
-- MG1
-- =============================================
if (policy == "MG1") then
	-- Creating stages table
	stages[1] = stage1
	stages[2] = stage2

	-- Configuring priority between stages
	mg1.configure(stages, cores, 1, true)
end

-- =============================================
-- DBR
-- =============================================
if (policy == "SEDA") then
	-- Creating stages table
	stages[1] = stage1
	stages[2] = stage2

	-- Configuring priority between stages
	seda.configure(stages, cores)
end

-- =============================================
-- DYNAMIC
-- =============================================
if (policy == "DYNAMIC") then
	-- Creating stages table
	stages[1] = stage1
	stages[2] = stage2
	stages[3] = stage3

	local conf 	       = {}
	local minThreads       = 2
	local queueThreshold   = 50
	local activePercentage = 10	
	local refresh 	       = 5
	local idlePercentage   = 70
	
	-- Configuration
	conf.stages  	      = stages
	conf.maxThreads       = minThreads + 2
	conf.minThreads       = minThreads
	conf.queueThreshold   = queueThreshold 
	conf.refreshSeconds   = refresh
	conf.idlePercentage   = idlePercentage
	conf.activePercentage = activePercentage

	-- Configuring priority between stages
	dynamic.configure(conf)
end

on_timer=function(id)
	if (policy == "MG1") then
		mg1.on_timer(id)
	end
	
	if (policy == "DYNAMIC") then
		dynamic.on_timer(id)
	end
end

-- Dispatch on_timer events
lstage.dispatchevents()

-- Avoid script to close
lstage.channel():get() 
