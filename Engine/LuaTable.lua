--This file is part of Robotics2D--
--[[
  * Copyright 2016 Rami Sabbagh
  * 
  * Licensed under the Apache License, Version 2.0 (the "License");
  * you may not use this file except in compliance with the License.
  * You may obtain a copy of the License at
  * 
  *     http://www.apache.org/licenses/LICENSE-2.0
  * 
  * Unless required by applicable law or agreed to in writing, software
  * distributed under the License is distributed on an "AS IS" BASIS,
  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  * See the License for the specific language governing permissions and
  * limitations under the License.
--]]

--[[A library that can be used to covert tables to Lua files that can be saved.
Since it uses Lua to save the data, It's able to save functions ! by dumping them, But they won't be readable, only loadable, unless if you decompile them.
And moreover you can do some hand written tables with smart data generator..
The bad thing that it's less secure .., So load the files using this Library to sandbox the files

usage:
luacode = LuaTable.encode(variable,funcBehave)
luacode = LuaTable.encode_pretty(variable,funcBehave)

variable:
Supported types: nil,boolean,string,number,table,function,userdata

funcBehave:
"dump" to dump the functions so they can be loaded again, But not recomended.
"name" to use tostring on the function, I guess it's useless, unless if it's used to debug something like the _G var.
"skip" (default) to skip the functions and not include them in the table.


example:
local LuaTable = require("Engine.LuaTable")
love.filesystem.write("TestTable.lua",LuaTable.encode({test=true}))

note: all Userdata variables can't be dumped so they will get dumped.
]]

local LuaTable = {}

function LuaTable.encode(var,funcBehave)
  local code = "local function combine(t1,t2) for k,v in pairs(t2) do t1[k] = v end return t1 end\nreturn "
  local vx = "nil" if LuaTable["encode_"..type(var)] then vx = LuaTable["encode_"..type(var)](var) end
  code = code..vx
  return code
end

function LuaTable.encode_pretty(var,funcBehave)
  local code = "local function combine(t1,t2)\n   for k,v in pairs(t2) do\n      t1[k] = v\n   end\n   return t1\nend\n\nreturn "
  local vx = "nil" if LuaTable["encode_"..type(var)] then vx = LuaTable["encode_"..type(var)](var,"   ",funcBehave) end
  code = code..vx
  return code
end

function LuaTable.isArray(table)
  for k,v in pairs(table) do
    if type(k) ~= "number" then
      return false
    end
  end
  return true
end

---
--Here you can add your own variable types.
--Array is a numeric table.

function LuaTable.encode_array(table,pretty,funcBehave)
  local s = "{"
  for i=1,#table do
    if pretty then
      local vx = "nil" if LuaTable["encode_"..type(table[i])] then vx = LuaTable["encode_"..type(table[i])](table[i],pretty.."   ",funcBehave) end
      if i==1 then
        s = s..pretty..vx
      else
        s = s..",\n"..pretty..vx
      end
    else
      local vx = "nil" if LuaTable["encode_"..type(table[i])] then vx = LuaTable["encode_"..type(table[i])](table[i],nil,funcBehave) end
      if i==1 then
        s = s..vx
      else
        s = s..","..vx
      end
    end
  end
  return s.."}"
end

function LuaTable.encode_table(table,pretty,funcBehave)
  if LuaTable.isArray(table) then return LuaTable.encode_array(table,pretty) end
  local nums, first = {}, true
  local s = "{"
  for k,v in pairs(table) do
    if pretty then
      local vx = "nil" if LuaTable["encode_"..type(v)] then vx = LuaTable["encode_"..type(v)](v,pretty.."   ",funcBehave) end
      if type(k) == "number" then
        nums[k] = v
      elseif first then
        s = s.."\n"..pretty..tostring(k).." = "..vx
        first = false
      else
        s = s..",\n"..pretty..tostring(k).." = "..vx
      end
    else
      local vx = "nil" if LuaTable["encode_"..type(v)] then vx = LuaTable["encode_"..type(v)](v,nil,funcBehave) end
      if type(k) == "number" then
        nums[k] = v
      elseif first then
        s = s..tostring(k).."="..vx
        first = false
      else
        s = s..","..tostring(k).."="..vx
      end
    end
  end
  if #nums > 0 then
    if pretty then
      s = "combine("..s.."},"..LuaTable.encode_array(nums,pretty.."   ")..")"
    else
      s = "combine("..s.."},"..LuaTable.encode_array(nums)..")"
    end
  else
    s = s.."}"
  end
  return s
end

function LuaTable.encode_function(func,pretty,funcBehave)
  local fmode = funcBehave or "skip"
  if fmode == "dump" then return string.dump(func)
  elseif fmode == "name" then return '"'..tostring(func)..'"'
  else return "nil" end
end

function LuaTable.encode_userdata(ud,pretty,funcBehave)
  if funcBehave and funcBehave == "name" then return '"'..tostring(ud)..'"' else return "nil" end
end

function LuaTable.encode_nil()
  return "nil"
end

function LuaTable.encode_string(string)
  return '[['..tostring(string)..']]'
end

function LuaTable.encode_number(number)
  return tostring(number)
end

function LuaTable.encode_boolean(boolean)
  if boolean then
    return "true"
  else
    return "false"
  end
end

return LuaTable