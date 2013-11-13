note
	description: "Summary description for {GL2D_WORLD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GL_WORLD

inherit
	GL_OBJECT

feature -- Access

	clear_buffers(a_color_buffer,a_depth_buffer,a_stencil_buffer:BOOLEAN)
		local
			l_flags:NATURAL_32
		do
			l_flags:=0
			if a_color_buffer then
				l_flags:=l_flags.bit_or ({GL_GL_EXTERNAL}.GL_COLOR_BUFFER_BIT)
			end
			if a_depth_buffer then
				l_flags:=l_flags.bit_or ({GL_GL_EXTERNAL}.GL_DEPTH_BUFFER_BIT)
			end
			if a_stencil_buffer then
				l_flags:=l_flags.bit_or ({GL_GL_EXTERNAL}.GL_STENCIL_BUFFER_BIT)
			end
			{GL_GL_EXTERNAL}.glClear({GL_GL_EXTERNAL}.GL_COLOR_BUFFER_BIT.bit_or ({GL_GL_EXTERNAL}.GL_DEPTH_BUFFER_BIT))
		end

end
