note
	description: "[
						A {GAME_WINDOW} that directly use {GAME_SURFACE} to render.
						Note that {GAME_WINDOW_SURFACED} don't use hardware acceleration and is very slow.
						It should be use for slow application only. To use hardware acceleration,
						use the {GAME_WINDOW_RENDERED} type.
					]"
	author: "Louis Marchand"
	date: "January 14, 2014"
	revision: "2.0.0.1"

class
	GAME_WINDOW_SURFACED

inherit
	GAME_WINDOW
	GAME_DRAWING_TOOLS


create
	make,
	make_default,
	make_on_display,
	make_with_position,
	make_centered,
	make_fullscreen,
	make_with_extra_flags

feature -- Access

	surface:GAME_SURFACE
		local
			l_surface_pointer:POINTER
			l_source:GAME_IMAGE
		do
			if attached internal_surface as la_surface then
				Result:=la_surface
			else
				l_surface_pointer:={GAME_SDL_EXTERNAL}.SDL_GetWindowSurface(item)
				create l_source.share_from_pointer (l_surface_pointer)
				if l_source.is_openable then
					l_source.open
					if l_source.is_open then
						create internal_surface.share_from_image (l_source)
						Result:=surface
					else
						io.error.put_string ("An error occured while creating the surfaced window.%N")
						has_error:=True
						create Result.make_for_window (Current, 0, 0)
					end
				else
					io.error.put_string ("An error occured while creating the surfaced window.%N")
					has_error:=True
					create Result.make_for_window (Current, 0, 0)
				end
				check not has_error end
			end
		end

	update
		local
			l_error:INTEGER
		do
			clear_error
			l_error:={GAME_SDL_EXTERNAL}.SDL_UpdateWindowSurface(item)
			manage_error_code(l_error, "An error occured while updating the window surface.")
		end

	update_rectangle(a_x, a_y, a_width, a_height:INTEGER)
		local
			l_normalized_rectangle:TUPLE[x, y, width, height:INTEGER]
		do
			update_rectangles(create {ARRAYED_LIST[TUPLE[x, y, width, height:INTEGER]]}.make_from_array (
					<<[a_x, a_y, a_width, a_height]>>))
		end

	update_rectangles(a_rectangles:CHAIN[TUPLE[x, y, width, height:INTEGER]])
			-- Drawing every wire rectangle in `a_rectangles'
			-- that has it's left frontier at
			-- `x', it's top frontier at `y', with
			-- dimension `width'x`height'
		require
			Renderer_exists: exists
		local
			l_array_rectangles, l_rectangle:POINTER
			l_rectangle_size, l_error:INTEGER
			l_normalized_rectangle:TUPLE[x, y, width, height:INTEGER]
		do
			l_rectangle_size := {GAME_SDL_EXTERNAL}.c_Sizeof_sdl_rect
			l_array_rectangles := l_array_rectangles.memory_alloc (l_rectangle_size * a_rectangles.count)
			l_rectangle := l_array_rectangles
			across a_rectangles as la_rectangles loop
				l_normalized_rectangle := normalize_rectangle (la_rectangles.item.x, la_rectangles.item.y, la_rectangles.item.width, la_rectangles.item.height)
				{GAME_SDL_EXTERNAL}.set_rect_struct_x(l_rectangle,l_normalized_rectangle.x)
				{GAME_SDL_EXTERNAL}.set_rect_struct_y(l_rectangle,l_normalized_rectangle.y)
				{GAME_SDL_EXTERNAL}.set_rect_struct_w(l_rectangle,l_normalized_rectangle.width)
				{GAME_SDL_EXTERNAL}.set_rect_struct_h(l_rectangle,l_normalized_rectangle.height)
				l_rectangle := l_rectangle.plus (l_rectangle_size)
			end
			clear_error
			l_error := {GAME_SDL_EXTERNAL}.SDL_UpdateWindowSurfaceRects(item, l_array_rectangles, a_rectangles.count)
			manage_error_code (l_error, "An error occured while updating the screen.")
			l_array_rectangles.memory_free
		end

feature {NONE} -- Implementation

	internal_surface:detachable GAME_SURFACE

-- Todo:
		-- http://wiki.libsdl.org/SDL_UpdateWindowSurfaceRects

end
