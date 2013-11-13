note
	description: "Summary description for {GL_CONTROLLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GL_CONTROLLER

inherit
	GAME_LIB_CONTROLLER
	undefine
		create_screen_surface,
		flip_screen
	end

create
	make,
	make_no_parachute

feature -- Video methods

	create_window_with_icon_cpf(a_cpf:CPF_PACKAGE_FILE;a_cpf_index:INTEGER;a_transparent_color:GAME_COLOR;a_width,a_height,a_bits_per_pixel:INTEGER;a_has_hardware_dbl_buf,a_is_resisable,a_with_frame,a_fullscreen:BOOLEAN)
		-- Create a window with a new screen surface and set the icon.
		-- The image in the custom package file `a_cpf' must point to a standard bmp file. On MS Windows, the bmp file must be 32x32 pixels.
		-- If `a_transparent_color' is void, the icon will be opaque. To use a transparent color, you must convert your bmp in 8 bits indexed bitmap image.
		-- The flags `a_in_video_memory' is useless with OpenGL. `a_has_hardware_dbl_buf' can be use if the graphic card support it.
	require
		Controller_Create_Screen_Is_Video_Enable: is_video_enable
	do
		create_screen_surface_with_icon_cpf(a_cpf,a_cpf_index,a_transparent_color,a_width,a_height,a_bits_per_pixel,False,a_has_hardware_dbl_buf,a_is_resisable,a_with_frame,a_fullscreen)
	ensure
		Create_Screen_Not_Void: screen_is_create
	end

	create_window_with_icon(a_icon_filename:STRING;a_transparent_color:GAME_COLOR;a_width,a_height,a_bits_per_pixel:INTEGER;a_has_hardware_dbl_buf,a_is_resisable,a_with_frame,a_fullscreen:BOOLEAN)
		-- Create a window with a new screen surface and set the icon.
		-- The `a_icon_filename' must point to a standard bmp file. On MS Windows, the bmp file must be 32x32 pixels.
		-- If `a_transparent_color', the icon will be opaque.
		-- The flags `a_in_video_memory' is useless with OpenGL. `a_has_hardware_dbl_buf' can be use if the graphic card support it.
	require
		Controller_Create_Screen_Is_Video_Enable: is_video_enable
	do
		create_screen_surface_with_icon(a_icon_filename,a_transparent_color,a_width,a_height,a_bits_per_pixel,False,a_has_hardware_dbl_buf,a_is_resisable,a_with_frame,a_fullscreen)
	ensure
		Create_Screen_Not_Void: screen_is_create
	end

	create_window(a_width,a_height,a_bits_per_pixel:INTEGER;a_has_hardware_dbl_buf,a_is_resisable,a_with_frame,a_fullscreen:BOOLEAN)
		require
			Controller_Create_Screen_Is_Video_Enable: is_video_enable
		do
			create_screen_surface(a_width,a_height,a_bits_per_pixel,False,a_has_hardware_dbl_buf,a_is_resisable,a_with_frame,a_fullscreen)
		ensure
			Create_Screen_Not_Void: screen_is_create
		end

	create_screen_surface(a_width,a_height,a_bits_per_pixel:INTEGER;a_in_video_memory,a_has_hardware_dbl_buf,a_is_resisable,a_with_frame,a_fullscreen:BOOLEAN)
		-- Create a window with a new screen surface.
		-- The flags `a_in_video_memory' is useless with OpenGL. `a_has_hardware_dbl_buf' can be use if the graphic card support it.
	local
		l_flags:NATURAL_32
		l_error:INTEGER
	do
		l_error:={GL_SDL_EXTERNAL}.SDL_GL_SetAttribute( {GL_SDL_EXTERNAL}.SDL_GL_DEPTH_SIZE, a_bits_per_pixel );
		check l_error=0 end
		l_flags:={GL_SDL_EXTERNAL}.SDL_OPENGL
		has_hardware_double_buffer:=a_has_hardware_dbl_buf
		if has_hardware_double_buffer then
			l_error:={GL_SDL_EXTERNAL}.SDL_GL_SetAttribute( {GL_SDL_EXTERNAL}.SDL_GL_DOUBLEBUFFER, 1 );
		else
			l_error:={GL_SDL_EXTERNAL}.SDL_GL_SetAttribute( {GL_SDL_EXTERNAL}.SDL_GL_DOUBLEBUFFER, 0 );
		end
		check l_error=0 end
		if a_is_resisable then
			l_flags:=l_flags | {GAME_SDL_EXTERNAL}.SDL_RESIZABLE
		end
		if not a_with_frame then
			l_flags:=l_flags | {GAME_SDL_EXTERNAL}.SDL_NOFRAME
		end
		if a_fullscreen then
			l_flags:=l_flags | {GAME_SDL_EXTERNAL}.SDL_FULLSCREEN
		end
		scr_surface:=create {GAME_SCREEN}.make(a_width,a_height,a_bits_per_pixel,l_flags)
		create world
	end

	flip_screen
			-- Show the screen surface in the window
		local
		do
			if has_hardware_double_buffer then
				{GL_SDL_EXTERNAL}.SDL_GL_SwapBuffers
			else
				{GL_GL_EXTERNAL}.glFlush
			end
		end

	wait_for_finish
		do
			{GL_GL_EXTERNAL}.glFinish
		end

	world:GL_WORLD

end
