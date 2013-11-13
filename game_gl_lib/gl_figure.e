note
	description: "Summary description for {GL_FIGURE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	GL_FIGURE

inherit
	GL_OBJECT
	GL_EXCEPTION_HELPER

feature {NONE} -- Initialisation

	make_multiple(a_vertices:ITERABLE[TUPLE[x,y,z:REAL_64]])
			-- Create a figure from multiple vertices.
		require
			a_vertices_not_void:a_vertices/=Void
		do
			vertices:=a_vertices
			set_colors (create {ARRAY[GAME_COLOR]}.make_empty)
			init_figure
			set_lines_stipple_multiplier (1)
			set_lines_stipple_pattern (0xFFFF)
			set_lines_width (1)
			disable_lines_stipple
			set_points_size(1.0)
		end

	init_figure
		deferred
		end

feature -- Access

	vertices:ITERABLE[TUPLE[x,y,z:REAL_64]] assign set_vertices
			-- Vertices to form the {GL_FIGURE} `Current'.

	set_vertices(a_vertices:ITERABLE[TUPLE[x,y,z:REAL_64]])
			-- Assign the `a_vertices' to the `vertices' to form the {GL_FIGURE} `Current'.
		require
			a_vertices_not_void:a_vertices/=Void
		do
			vertices:=a_vertices
		end

	colors:ITERABLE[GAME_COLOR] assign set_colors
			-- Sequence of colors assoriate with `vertices'.

	set_colors(a_colors:ITERABLE[GAME_COLOR])
			-- Assign the sequence `a_colors' to the sequence `colors' associate with `vertices'
		do
			colors:=a_colors
		end

	default_color:GAME_COLOR assign set_default_color

	set_default_color(a_color:GAME_COLOR)
		do
			default_color:=a_color
		end

	is_lines_stipple_enabled:BOOLEAN

	enable_lines_stipple
		do
			is_lines_stipple_enabled:=true
		end

	disable_lines_stipple
		do
			is_lines_stipple_enabled:=False
		end

	lines_stipple_pattern:NATURAL_16 assign set_lines_stipple_pattern

	set_lines_stipple_pattern(a_stipple_pattern:NATURAL_16)
		do
			lines_stipple_pattern:=a_stipple_pattern
		end

	lines_stipple_multiplier:INTEGER assign set_lines_stipple_multiplier

	set_lines_stipple_multiplier(a_stipple_multiplier:INTEGER)
		require
			A_Stipple_Multiplier_Valid: a_stipple_multiplier>=1 and a_stipple_multiplier<=256
		do
			lines_stipple_multiplier:=a_stipple_multiplier
		end

	lines_width:REAL_32 assign set_lines_width

	set_lines_width(a_width:REAL_32)
		require
			A_Width_Vaild: a_width > 0 and then a_width>= Min_lines_width and a_width <= Max_lines_width
		do
			lines_width:=a_width
		end

	points_size:REAL_32 assign set_points_size

	set_points_size(a_size:REAL_32)
		require
			A_Size_Valid: a_size>0.0 and then a_size>=Min_points_size and a_size<=Max_points_size
		do
			points_size:=a_size
		end

	draw
		local
			l_color_cursor:ITERATION_CURSOR[GAME_COLOR]
		do
			{GL_GL_EXTERNAL}.glPointSize(points_size)
			check_for_error
			if is_lines_stipple_enabled then
				{GL_GL_EXTERNAL}.glEnable({GL_GL_EXTERNAL}.GL_LINE_STIPPLE)
				check_for_error
				{GL_GL_EXTERNAL}.glLineStipple(lines_stipple_multiplier, lines_stipple_pattern)
				check_for_error
			else
				{GL_GL_EXTERNAL}.glDisable({GL_GL_EXTERNAL}.GL_LINE_STIPPLE)
				check_for_error
			end
			{GL_GL_EXTERNAL}.glLineWidth(lines_width)
			{GL_GL_EXTERNAL}.glBegin(gl_primitive_const)
			across
				vertices as l_vertices
			from
				l_color_cursor:=colors.new_cursor
			loop
				if not l_color_cursor.after then
					{GL_GL_EXTERNAL}.glColor4ub(l_color_cursor.item.red,l_color_cursor.item.green,l_color_cursor.item.blue,l_color_cursor.item.alpha)
					l_color_cursor.forth
				elseif default_color/=Void then
					{GL_GL_EXTERNAL}.glColor4ub(default_color.red,default_color.green,default_color.blue,default_color.alpha)
				end
				{GL_GL_EXTERNAL}.glVertex3d(l_vertices.item.x,l_vertices.item.y,l_vertices.item.z)
			end
			{GL_GL_EXTERNAL}.glEnd
			check_for_error
		end


feature -- Constants

	Min_lines_width:REAL_32
		local
			l_params_vector:ARRAY[REAL_32]
			l_params_c:ANY
		once
			create l_params_vector.make_filled (0.0, 1, 2)
			l_params_c:=l_params_vector.to_c
			{GL_GL_EXTERNAL}.glGetFloatv({GL_GL_EXTERNAL}.GL_LINE_WIDTH_RANGE,$l_params_c)
			Result:=l_params_vector.at (1)
		end

	Max_lines_width:REAL_32
		local
			l_params_vector:ARRAY[REAL_32]
			l_params_c:ANY
		once
			create l_params_vector.make_filled (0.0, 1, 2)
			l_params_c:=l_params_vector.to_c
			{GL_GL_EXTERNAL}.glGetFloatv({GL_GL_EXTERNAL}.GL_LINE_WIDTH_RANGE,$l_params_c)
			Result:=l_params_vector.at (2)
		end

	Min_points_size:REAL_32
		local
			l_params_vector:ARRAY[REAL_32]
			l_params_c:ANY
		once
			create l_params_vector.make_filled (0.0, 1, 1)
			l_params_c:=l_params_vector.to_c
			{GL_GL_EXTERNAL}.glGetFloatv({GL_GL_EXTERNAL}.GL_POINT_SIZE_MIN,$l_params_c)
			Result:=l_params_vector.at (1)
		end

	Max_points_size:REAL_32
		local
			l_params_vector:ARRAY[REAL_32]
			l_params_c:ANY
		once
			create l_params_vector.make_filled (0.0, 1, 1)
			l_params_c:=l_params_vector.to_c
			{GL_GL_EXTERNAL}.glGetFloatv({GL_GL_EXTERNAL}.GL_POINT_SIZE_MAX,$l_params_c)
			Result:=l_params_vector.at (1)
		end

feature {NONE} -- Implementation

	gl_primitive_const:NATURAL_32

invariant
	Points_Size_Valid: points_size>=Min_points_size and points_size<=Max_points_size
	Lines_Width_Vaild: lines_width > 0 and then lines_width>= Min_lines_width and lines_width <= Max_lines_width
	Lines_Stipple_Multiplier_Valid: lines_stipple_multiplier>=1 and lines_stipple_multiplier<=256
	Gl_Primitive_Is_Set: gl_primitive_const /= gl_primitive_const.max_value
	Vertices_valid: vertices/=Void
	Colors_valid: colors/=Void


end
