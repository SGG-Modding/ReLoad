---@meta SGG_Modding-ReLoad
local reload = {}

---@alias SGG_Modding-ReLoad*on_any_load fun(triggerArgs:table)
---@alias SGG_Modding-ReLoad*on_pre_import fun(script: string, env: table)
---@alias SGG_Modding-ReLoad*on_post_import fun(script: string)

--[[
          Defines a new trigger (event that can be listed to when queuing loads)
]]
---@param name string valid field name for the trigger, can't overlap other triggers
---@param func fun(poll: fun(...)) what actually implements the trigger, it can invoke `poll` any amount of times.
---@param ready any
function reload.trigger(name,func,ready) end

--[[
          Signals a load or reload of the file identified by the `signature`, invoking the appropriate callbacks.
]]
---@param signature any *globally unique* identifier for the file being reloaded, if nil it will always be considered the first load. 
---@param on_ready fun() only run on the first load, **not** on any reloads
---@param on_reload fun()? run on the first load (after `on_ready`), and also on and any reloads
function reload.load(signature,on_ready,on_reload) end

reload.queue = {}

---@param sig any *globally unique* identifier for the file being reloaded, if nil it will always be considered the first load
---@param update fun() callback to run on every imgui draw update, regardless of if the mod UI is on
---@param on_ready fun()? only run on the first load, **not** on any reloads
---@param on_reload fun()? run on the first load (after `on_ready`), and also on and any reloads
function reload.queue.on_update(sig,update,on_ready,on_reload) end

---@param sig any *globally unique* identifier for the file being reloaded, if nil it will always be considered the first load
---@param on_pre_import SGG_Modding-ReLoad*on_pre_import
---@param on_ready fun()? only run on the first load, **not** on any reloads
---@param on_reload fun()? run on the first load (after `on_ready`), and also on and any reloads
function reload.queue.on_pre_import(sig,on_pre_import,on_ready,on_reload) end

---@param sig any *globally unique* identifier for the file being reloaded, if nil it will always be considered the first load
---@param on_post_import SGG_Modding-ReLoad*on_post_import
---@param on_ready fun()? only run on the first load, **not** on any reloads
---@param on_reload fun()? run on the first load (after `on_ready`), and also on and any reloads
function reload.queue.post_import(sig,on_post_import,on_ready,on_reload) end

---@param sig any *globally unique* identifier for the file being reloaded, if nil it will always be considered the first load
---@param any_load SGG_Modding-ReLoad*on_any_load
---@param on_ready fun()? only run on the first load, **not** on any reloads
---@param on_reload fun()? run on the first load (after `on_ready`), and also on and any reloads
function reload.queue.any_load(sig,any_load,on_ready,on_reload) end

---@param sig any *globally unique* identifier for the file being reloaded, if nil it will always be considered the first load
---@param script string filename of the script file to wait to until it begins being imported
---@param on_pre_import_file SGG_Modding-ReLoad*on_pre_import
---@param on_ready fun()? only run on the first load, **not** on any reloads
---@param on_reload fun()? run on the first load (after `on_ready`), and also on and any reloads
---@param ... any extra arguments to pass into OnAnyLoad's args table
function reload.queue.pre_import_file(sig,script,on_pre_import_file,on_ready,on_reload,...) end

---@param sig any *globally unique* identifier for the file being reloaded, if nil it will always be considered the first load
---@param script string filename of the script file to wait to have been imported
---@param on_post_import_file SGG_Modding-ReLoad*on_post_import
---@param on_ready fun()? only run on the first load, **not** on any reloads
---@param on_reload fun()? run on the first load (after `on_ready`), and also on and any reloads
function reload.queue.post_import_file(sig,script,on_post_import_file,on_ready,on_reload) end

--[[
          Bound functions, in this case bound *without a signature*, so it will always be considered the first load.
]]
---@class SGG_Modding-ReLoad*binds.auto: table
---@field public load fun(on_ready: fun(),on_reload: fun())
---@field public queue SGG_Modding-ReLoad*binds.auto.queue

--[[
          Bound functions, in this case bound *to a plugin environment*, so it can only be used one time per trigger.
]]
---@class SGG_Modding-ReLoad*binds.auto_single: table
---@field public load fun(on_ready: fun(),on_reload: fun())
---@field public queue SGG_Modding-ReLoad*binds.auto_single.queue

--[[
          Bound functions, in this case bound *to a file signature prefix*, so it can only be used multiple times per trigger, but a *file-locally unique* signature must be given to each.
]]
---@class SGG_Modding-ReLoad*binds.auto_multiple: table
---@field public load fun(sig: any, on_ready: fun(),on_reload: fun()?)
---@field public queue SGG_Modding-ReLoad*binds.auto_multiple.queue

---@class SGG_Modding-ReLoad*binds.auto.queue: table
---@field public on_update fun(update: fun(),on_ready: fun()?,on_reload: fun()?)
---@field public on_pre_import fun(on_pre_import: SGG_Modding-ReLoad*on_pre_import,on_ready: fun()?,on_reload: fun()?)
---@field public post_import fun(on_post_import: SGG_Modding-ReLoad*on_post_import,on_ready: fun()?,on_reload: fun()?)
---@field public any_load fun(any_load: SGG_Modding-ReLoad*on_any_load,on_ready: fun()?,on_reload: fun()?)
---@field public pre_import_file fun(script,on_pre_import_file: SGG_Modding-ReLoad*on_pre_import,on_ready: fun()?,on_reload: fun()?)
---@field public post_import_file fun(script,on_post_import_file: SGG_Modding-ReLoad*on_post_import,on_ready: fun()?,on_reload: fun()?)

---@class SGG_Modding-ReLoad*binds.auto_single.queue: table
---@field public on_update fun(update: fun(),on_ready: fun(),on_reload: fun())
---@field public on_pre_import fun(on_pre_import: SGG_Modding-ReLoad*on_pre_import,on_ready: fun()?,on_reload: fun()?)
---@field public post_import fun(on_post_import: SGG_Modding-ReLoad*on_post_import,on_ready: fun()?,on_reload: fun()?)
---@field public any_load fun(any_load: SGG_Modding-ReLoad*on_any_load,on_ready: fun()?,on_reload: fun()?)
---@field public pre_import_file fun(script,on_pre_import_file: SGG_Modding-ReLoad*on_pre_import,on_ready: fun()?,on_reload: fun()?)
---@field public post_import_file fun(script,on_post_import_file: SGG_Modding-ReLoad*on_post_import,on_ready: fun()?,on_reload: fun()?)

---@class SGG_Modding-ReLoad*binds.auto_multiple.queue: table
---@field public on_update fun(sig: any, update: fun(),on_ready: fun()?,on_reload: fun()?)
---@field public on_pre_import fun(sig: any, on_pre_import: SGG_Modding-ReLoad*on_pre_import,on_ready: fun()?,on_reload: fun()?)
---@field public post_import fun(sig: any, on_post_import: SGG_Modding-ReLoad*on_post_import,on_ready: fun()?,on_reload: fun()?)
---@field public any_load fun(sig: any, any_load: SGG_Modding-ReLoad*on_any_load,on_ready: fun()?,on_reload: fun()?)
---@field public pre_import_file fun(sig: any, script,on_pre_import_file: SGG_Modding-ReLoad*on_pre_import,on_ready: fun()?,on_reload: fun()?)
---@field public post_import_file fun(sig: any, script,on_post_import_file: SGG_Modding-ReLoad*on_post_import,on_ready: fun()?,on_reload: fun()?)

---@return SGG_Modding-ReLoad*binds.auto binds
function reload.auto() end

---@return SGG_Modding-ReLoad*binds.auto_single binds
function reload.auto_single() end

---@return SGG_Modding-ReLoad*binds.auto_multiple binds
function reload.auto_multiple() end

return reload