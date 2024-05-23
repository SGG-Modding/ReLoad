---@meta _
---@diagnostic disable

local rom = rom or _G
---@module 'SGG_Modding-ENVY'
local envy = rom.mods['SGG_Modding-ENVY']
---@module 'SGG_Modding-ENVY-auto'
envy.auto()

local order = {}
local loaded = {}
local queued = {}
local triggers = {}

local function handle_load(sig,on_ready,on_reload)
	local first = true
	if sig ~= nil then
		first = not loaded[sig]
		loaded[sig] = true
	end
	if first and on_ready ~= nil then on_ready() end
	if on_reload ~= nil then on_reload() end
end

local function queue_load(trigger,sig,...)
	local args = table.pack(...)
	if sig == nil then
		local queue = queued[trigger]
		table.insert(queue,args)
	else
		if not loaded[sig] then
			table.insert(order,sig)
		end
		trigger[sig] = args
	end
end

local function array_join(a,b)
	local c = { }
	local j = 0
	for i, v in ipairs( a ) do
		c[ i ] = v
		j = i
	end
	for i, v in ipairs( b ) do
		c[ i + j ] = v
	end
	return c
end

local function vararg_join(args,...)
	local args = array_join( args, table.pack( ... ) )
	return table.unpack( args )
end

local function inner_check_ready_queued(cargs,args,queue,idx)
	local is_ready, on_ready, on_reload = table.unpack(args,1,3)
	if is_ready(vararg_join(cargs,table.unpack(args,4,args.n))) then
		queue[idx] = true
		handle_load(nil,on_ready,on_reload)
	end
end

local function inner_check_ready_trigger(cargs,args,trigger,sig)
	local is_ready, on_ready, on_reload = table.unpack(args,1,3)
	if is_ready(vararg_join(cargs,table.unpack(args,4,args.n))) then
		trigger[sig] = nil
		handle_load(sig,on_ready,on_reload)
	end
end

local queue_to_remove = {}

local function check_ready(trigger,...)
	local cargs = table.pack(...)
	local queue = queued[trigger]
	local n = #queue
	if n > 0 then
		for k in pairs(queue_to_remove) do
			queue_to_remove[k] = nil
		end
	end
	for i = 1, n, 1 do
		local args = queue[i]
		inner_check_ready_queued(cargs,args,queue_to_remove,i)
	end
	for i = n, 1, -1 do
		if queue_to_remove[i] then
			table.remove(queue,i)
		end
	end
	for _, sig in ipairs(order) do
		local args = trigger[sig]
		if args ~= nil then
			inner_check_ready_trigger(cargs,args,trigger,sig)
		end
	end
end

local function get_sig(level)
	if level == nil then level = 0 end
	level = level + 1
	local env = envy.getfenv(level)
	local info = debug.getinfo(level,'S')
	local sig = info.source
	if env._PLUGIN then
		sig = env._PLUGIN.guid .. '|' .. sig
	end
	return sig
end

function public.trigger(name,func,ready)
	local trigger = {}
	queued[trigger] = {}
	local queue = function(...)
		return queue_load(trigger,...)
	end
	if ready ~= nil then
		public.queue[name] = function(sig,rarg,...)
			return queue(sig,ready(rarg,...),...)
		end
	else
		public.queue[name] = function(sig,...)
			return queue(sig,...)
		end
	end
	local check = function(...)
		return check_ready(trigger,...)
	end
	func(check)
end

public.queue = {}
public.load = handle_load
function public.auto()
	local binds = {}
	binds.load = function(...)
		return handle_load(nil,...)
	end
	binds.queue = {}
	for k,v in pairs(public.queue) do
		binds.queue[k] = function(...)
			return v(nil,...)
		end
	end
	return binds
end
function public.auto_single()
	local sig = get_sig(2)
	local binds = {}
	binds.load = function(...)
		return handle_load(sig,...)
	end
	binds.queue = {}
	for k,v in pairs(public.queue) do
		binds.queue[k] = function(...)
			return v(sig,...)
		end
	end
	return binds
end
function public.auto_multiple()
	local sig = get_sig(2)
	local binds = {}
	binds.load = function(sig2,...)
		return handle_load(sig .. '|' .. sig2,...)
	end
	binds.queue = {}
	for k,v in pairs(public.queue) do
		binds.queue[k] = function(sig2,...)
			return v(sig .. '|' .. sig2,...)
		end
	end
	return binds
end

-- game specific
import('triggers.lua')