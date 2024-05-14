---@meta _
---@diagnostic disable

trigger('on_update',rom.gui.add_always_draw_imgui)
trigger('pre_import',rom.on_import.pre)
trigger('post_import',rom.on_import.post)
trigger('any_load',function(...) return rom.game.OnAnyLoad{...} end)
trigger('pre_import_file',rom.on_import.pre,function(cname)
	return function(name)
		if name == cname then
			return true
		end
	end
end)
trigger('post_import_file',rom.on_import.post,function(cname)
	return function(name)
		if name == cname then
			return true
		end
	end
end)