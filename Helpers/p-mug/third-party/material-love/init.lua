local material = {
	_VERSION     = 'material-love v1.0.0',
	_DESCRIPTION = 'Implementation of parts of the Material-Design spec, for LOVE',
	_URL         = 'https://www.github.com/Positive07/material-love',
	_LICENSE     = [[
		The Material Design Icon font is Licensed under SIL Open Font License 1.1
		https://github.com/Templarian/MaterialDesign/blob/master/license.txt
		
		Some of the icons are designed by Google and are under Copyright CC-BY
		https://github.com/google/material-design-icons/blob/master/LICENSE
		
		The Material-Love Library is Licensed under MIT License (MIT)

		Copyright (c) 2015 Pablo Mayobre

		Permission is hereby granted, free of charge, to any person obtaining a copy
		of this software and associated documentation files (the "Software"), to deal
		in the Software without restriction, including without limitation the rights
		to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
		copies of the Software, and to permit persons to whom the Software is
		furnished to do so, subject to the following conditions:

		The above copyright notice and this permission notice shall be included in all
		copies or substantial portions of the Software.

		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
		IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
		FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
		AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
		LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
		OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
		SOFTWARE.
	]]
}

local a = (...)..".libs."
local b = (...):gsub("%.","%/").."/assets"

local libs = {"nine", "icons", "ripple", "colors", "roundrect", "image", "spinner"}

for _,v in ipairs(libs) do
	material[v] = require(a..v)
end

material.fab = require (a.."fab")(b)
material.roboto = require (a.."roboto")(b)

material.shadow = {}
material.shadow.patch = material.nine.process(require (a.."shadow")(b))

material.shadow.draw = function (...)
	return material.shadow.patch:draw(...)
end

local drawicons = require (a.."drawicons")(b,material.icons,material.colors)
material.icons.draw = drawicons.draw
material.icons.font = drawicons.font

return material