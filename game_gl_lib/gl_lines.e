note
	description: "Summary description for {GL_LINES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GL_LINES

inherit
	GL_FIGURE
		rename
			Min_lines_width as Min_width,
			Max_lines_width as Max_width,
			set_lines_width as set_width,
			lines_width as width,
			set_lines_stipple_multiplier as set_stipple_multiplier,
			lines_stipple_multiplier as stipple_multiplier,
			set_lines_stipple_pattern as set_stipple_pattern,
			lines_stipple_pattern as stipple_pattern,
			disable_lines_stipple as disable_stipple,
			enable_lines_stipple as enable_stipple,
			is_lines_stipple_enabled as is_stipple_enabled
		end

create
	make,
	make_multiple

feature {NONE} -- Initialisation

	make(a_vertex_1,a_vertex_2:TUPLE[x,y,z:REAL_64])
		require
			a_vertex_1_not_void:a_vertex_1/=Void
			a_vertex_2_not_void:a_vertex_2/=Void
		do
			make_multiple(<< a_vertex_1,a_vertex_2 >>)
		end

	init_figure
		do
			disable_link
			disable_loop
			gl_primitive_const:={GL_GL_EXTERNAL}.GL_LINES
		end

feature -- Access

	is_linked:BOOLEAN
		do
			Result:= is_linked_imp or is_loop_imp
		end

	is_looped:BOOLEAN
		do
			Result:=is_loop_imp
		end

	enable_link
		do
			is_linked_imp:=True
			update_gl_primitive_const
		end

	enable_loop
		do
			is_loop_imp:=True
			update_gl_primitive_const
		end

	disable_link
		do
			is_linked_imp:=False
			update_gl_primitive_const
		end

	disable_loop
		do
			is_loop_imp:=False
			update_gl_primitive_const
		end



feature {NONE} -- Implementation

	update_gl_primitive_const
		do
			if is_looped then
				gl_primitive_const:={GL_GL_EXTERNAL}.GL_LINE_LOOP
			elseif is_linked then
				gl_primitive_const:={GL_GL_EXTERNAL}.GL_LINE_STRIP
			else
				gl_primitive_const:={GL_GL_EXTERNAL}.GL_LINES
			end
		end

	is_linked_imp:BOOLEAN
	is_loop_imp:BOOLEAN


end
