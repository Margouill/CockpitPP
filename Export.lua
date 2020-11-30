package.path  = package.path..";.\\LuaSocket\\?.lua"
package.cpath = package.cpath..";.\\LuaSocket\\?.dll"

local Cockpitpp=require('lfs'); dofile(Cockpitpp.writedir()..'Scripts/Cockpitpp.lua')
