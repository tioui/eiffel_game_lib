note
	description: "Summary description for {GL_POINTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"


class
	GL_POINTS

inherit
	GL_FIGURE
		rename
			Min_points_size as Min_size,
			Max_points_size as Max_size,
			set_points_size as set_size,
			points_size as size
		end

create
	make,
	make_multiple

feature {NONE} -- Initialisation

	make(a_vertex:TUPLE[x,y,z:REAL_64])
		require
			a_vertex_not_void:a_vertex/=Void
		do
			make_multiple(<< a_vertex >>)
		end

	init_figure
		do
			gl_primitive_const:={GL_GL_EXTERNAL}.GL_POINTS
		end


end
