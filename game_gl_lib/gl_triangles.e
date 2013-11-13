note
	description: "Summary description for {GL_TRIANGLES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GL_TRIANGLES

inherit
	GL_POLYGON
	rename
		make as make_multiple
	redefine
		init_figure
	end

create
	make,
	make_multiple

feature {NONE} -- Initialisation

	make(a_vertex_1,a_vertex_2,a_vertex_3:TUPLE[x,y,z:REAL_64])
		require
			a_vertex_1_not_void:a_vertex_1/=Void
			a_vertex_2_not_void:a_vertex_2/=Void
			a_vertex_3_not_void:a_vertex_3/=Void
		do
			make_multiple(<< a_vertex_1,a_vertex_2,a_vertex_3 >>)
		end

	init_figure
		do
			Precursor {GL_POLYGON}
			disable_link
			gl_primitive_const:={GL_GL_EXTERNAL}.GL_TRIANGLES
		end

feature -- Access

	is_linked_strip:BOOLEAN

	is_linked_fan:BOOLEAN

	enable_link_strip
		do
			is_linked_fan:=False
			is_linked_strip:=True
			gl_primitive_const:={GL_GL_EXTERNAL}.GL_TRIANGLE_STRIP
		end

	enable_link_fan
		do
			is_linked_strip:=False
			is_linked_fan:=True
			gl_primitive_const:={GL_GL_EXTERNAL}.GL_TRIANGLE_FAN
		end

	disable_link
		do
			is_linked_strip:=False
			is_linked_fan:=False
			gl_primitive_const:={GL_GL_EXTERNAL}.GL_TRIANGLES
		end

end
