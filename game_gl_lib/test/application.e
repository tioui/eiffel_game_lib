note
	description : "eiffel_gl_test application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
		local
			l_lib_controller:GL_CONTROLLER
			l_object1:GL_POINTS
			l_object2:GL_LINES
			l_object:GL_TRIANGLES
			l_object3:GL_POLYGON
		do
			create l_lib_controller.make
			l_lib_controller.enable_video
			l_lib_controller.create_window (640, 480, 16, true, False, True, False)
			l_lib_controller.world.clear_buffers (True, True, False)
			create l_object.make_multiple (<< [0.0,-0.5,0.0],[0.75,0.0,0.0],[-0.75,0.0,0.0],[-0.75,0.75,0.0],[0.75,0.75,0.0]  >>)
			l_object.colors:=<< create {GAME_COLOR}.make_rgb(255,255,0), create {GAME_COLOR}.make_rgb(0,255,255) >>
			l_object.default_color:=create {GAME_COLOR}.make_rgb(255,255,255)
			l_object.enable_clockwise_order
			l_object.enable_back_wired
		--	l_object.enable_ignore_back
			l_object.enable_lines_stipple
			l_object.set_lines_stipple_pattern (0xAAAA)
			l_object.set_lines_stipple_multiplier (2)
			l_object.draw
			{GL_GL_EXTERNAL}.glFlush
			l_lib_controller.flip_screen
			l_lib_controller.delay (5000)
			l_lib_controller.quit_library
		end

end
