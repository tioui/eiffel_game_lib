note
	description: "Summary description for {GL_QUADS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GL_QUADS

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

	make(a_vertex_1,a_vertex_2,a_vertex_3,a_vertex_4:TUPLE[x,y,z:REAL_64])
		require
			a_vertex_1_not_void:a_vertex_1/=Void
			a_vertex_2_not_void:a_vertex_2/=Void
			a_vertex_3_not_void:a_vertex_3/=Void
			a_vertex_4_not_void:a_vertex_4/=Void
		do
			make_multiple(<< a_vertex_1,a_vertex_2,a_vertex_3,a_vertex_4 >>)
		end

	init_figure
		do
			Precursor {GL_POLYGON}
			disable_link
			gl_primitive_const:={GL_GL_EXTERNAL}.GL_QUADS
		end

feature -- Access

	is_linked:BOOLEAN

	enable_link
		do
			is_linked:=True
			gl_primitive_const:={GL_GL_EXTERNAL}.GL_QUAD_STRIP
		end

	disable_link
		do
			is_linked:=False
			gl_primitive_const:={GL_GL_EXTERNAL}.GL_QUADS
		end
end
