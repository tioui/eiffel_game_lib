note
	description: "Creation of a polygon figure."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GL_POLYGON

inherit
	GL_FIGURE
	rename
		make_multiple as make
	redefine
		draw
	end

create
	make

feature {NONE} -- Initialisation

	init_figure
		do
			enable_back_filled
			enable_front_filled
			disable_clockwise_order
			disable_ignore_front
			disable_ignore_back
			gl_primitive_const:={GL_GL_EXTERNAL}.GL_POLYGON
		end

feature -- Access

	is_front_filled:BOOLEAN

	enable_front_filled
		do
			is_front_filled:=true
			is_front_wired:=false
			is_front_pointed:=false
		end

	is_front_wired:BOOLEAN

	enable_front_wired
		do
			is_front_filled:=false
			is_front_wired:=true
			is_front_pointed:=false
		end

	is_front_pointed:BOOLEAN

	enable_front_pointed
		do
			is_front_filled:=false
			is_front_wired:=false
			is_front_pointed:=true
		end

	is_back_filled:BOOLEAN

	enable_back_filled
		do
			is_back_filled:=true
			is_back_wired:=false
			is_back_pointed:=false
		end

	is_back_wired:BOOLEAN

	enable_back_wired
		do
			is_back_filled:=false
			is_back_wired:=true
			is_back_pointed:=false
		end

	is_back_pointed:BOOLEAN

	enable_back_pointed
		do
			is_back_filled:=false
			is_back_wired:=false
			is_back_pointed:=true
		end

	is_clockwise_order:BOOLEAN

	enable_clockwise_order
		do
			is_clockwise_order:=true
		end

	disable_clockwise_order
		do
			is_clockwise_order:=false
		end

	is_front_ignored:BOOLEAN

	enable_ignore_front
		do
			is_front_ignored:=True
		end

	disable_ignore_front
		do
			is_front_ignored:=False
		end

	is_back_ignored:BOOLEAN

	enable_ignore_back
		do
			is_back_ignored:=True
		end

	disable_ignore_back
		do
			is_back_ignored:=False
		end


	draw
		do
			if is_front_ignored or is_back_ignored then
				{GL_GL_EXTERNAL}.glEnable({GL_GL_EXTERNAL}.GL_CULL_FACE)
				check_for_error
				if is_front_ignored then
					{GL_GL_EXTERNAL}.glCullFace({GL_GL_EXTERNAL}.GL_FRONT)
				else
					{GL_GL_EXTERNAL}.glCullFace({GL_GL_EXTERNAL}.GL_BACK)
				end
				check_for_error
			else
				{GL_GL_EXTERNAL}.glDisable({GL_GL_EXTERNAL}.GL_CULL_FACE)
				check_for_error
			end
			if is_clockwise_order then
				{GL_GL_EXTERNAL}.glFrontFace({GL_GL_EXTERNAL}.GL_CW)
			else
				{GL_GL_EXTERNAL}.glFrontFace({GL_GL_EXTERNAL}.GL_CCW)
			end
			check_for_error
			if is_front_pointed then
				{GL_GL_EXTERNAL}.glPolygonMode({GL_GL_EXTERNAL}.GL_FRONT, {GL_GL_EXTERNAL}.GL_POINT)
			elseif is_front_wired then
				{GL_GL_EXTERNAL}.glPolygonMode({GL_GL_EXTERNAL}.GL_FRONT, {GL_GL_EXTERNAL}.GL_LINE)
			else
				{GL_GL_EXTERNAL}.glPolygonMode({GL_GL_EXTERNAL}.GL_FRONT, {GL_GL_EXTERNAL}.GL_FILL)
			end
			check_for_error
			if is_back_pointed then
				{GL_GL_EXTERNAL}.glPolygonMode({GL_GL_EXTERNAL}.GL_BACK, {GL_GL_EXTERNAL}.GL_POINT)
			elseif is_back_wired then
				{GL_GL_EXTERNAL}.glPolygonMode({GL_GL_EXTERNAL}.GL_BACK, {GL_GL_EXTERNAL}.GL_LINE)
			else
				{GL_GL_EXTERNAL}.glPolygonMode({GL_GL_EXTERNAL}.GL_BACK, {GL_GL_EXTERNAL}.GL_FILL)
			end
			check_for_error
			precursor
		end

invariant
	Front_Style_Valid:is_front_filled xor is_front_wired xor is_front_pointed
	Back_Style_Valid:is_back_filled xor is_back_wired xor is_back_pointed
end
