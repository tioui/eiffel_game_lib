note
	description: "A hardware accelerated picture in memory"
	author: "Louis Marchand"
	date: "2015, Febuary 2015"
	revision: "0.1"

class
	GAME_TEXTURE

inherit
	GAME_SDL_ANY
	DISPOSABLE
	GAME_RENDER_TARGET
	MEMORY_STRUCTURE
		rename
			make as make_structure
		export
			{NONE} shared, make_structure, make_by_pointer
			{GAME_SDL_ANY} item
		end
	GAME_BLENDABLE
		rename
			is_valid as exists
		end


create
	make_lockable,
	make_not_lockable,
	make_target,
	make_from_surface

feature {NONE} -- Initialization

	make(a_for_window:GAME_WINDOW_RENDERED; a_pixel_format:GAME_PIXEL_FORMAT_READABLE;
				a_access_flags, a_width, a_height:INTEGER)
			-- Initialization for `Current' of dimension (`a_width' , `a_height)
			-- for use on `a_for_window', having `a_pixel_format' and
			-- respecting `a_access_flags'.
		local
			l_item:POINTER
		do
			clear_error
			l_item := {GAME_SDL_EXTERNAL}.SDL_CreateTexture(
								a_for_window.renderer.item,
								a_pixel_format.internal_index, a_access_flags,
								a_width, a_height)
			manage_error_pointer(l_item, "Cannot create texture.")
			make_by_pointer(l_item)
		ensure
			Error_Or_Exist: not has_error implies exists
		end

	make_lockable(a_for_window:GAME_WINDOW_RENDERED; a_pixel_format:GAME_PIXEL_FORMAT_READABLE;
				a_width, a_height:INTEGER)
			-- Initialization for `Current' of dimension (`a_width' , `a_height)
			-- for use on `a_for_window', having `a_pixel_format'. `Current'
			-- can be locked to be modified (less speedy but more flexible)
		do
			make(a_for_window, a_pixel_format,
				{GAME_SDL_EXTERNAL}.SDL_TEXTUREACCESS_STREAMING,
				a_width, a_height)
		ensure
			Error_Or_Exist: not has_error implies exists
		end

	make_not_lockable(a_for_window:GAME_WINDOW_RENDERED; a_pixel_format:GAME_PIXEL_FORMAT_READABLE;
				a_width, a_height:INTEGER)
			-- Initialization for `Current' of dimension (`a_width' , `a_height)
			-- for use on `a_for_window', having `a_pixel_format'. `Current'
			-- can not be locked to be modified (best performance)
		do
			make(a_for_window, a_pixel_format,
				{GAME_SDL_EXTERNAL}.SDL_TEXTUREACCESS_STATIC,
				a_width, a_height)
		ensure
			Error_Or_Exist: not has_error implies exists
		end

	make_target(a_for_window:GAME_WINDOW_RENDERED; a_pixel_format:GAME_PIXEL_FORMAT_READABLE;
				a_width, a_height:INTEGER)
			-- Initialization for `Current' of dimension (`a_width' , `a_height)
			-- for use on `a_for_window', having `a_pixel_format'. `Current'
			-- can be used as rendering target (see: {GAME_RENDERER}.`render_target')
		do
			make(a_for_window, a_pixel_format,
				{GAME_SDL_EXTERNAL}.SDL_TEXTUREACCESS_TARGET,
				a_width, a_height)
		ensure
			Error_Or_Exist: not has_error implies exists
		end

	make_from_surface(a_for_window:GAME_WINDOW_RENDERED; a_surface:GAME_SURFACE)
			-- Initialization of `Current' for use on `a_for_window' and using
			-- the data of `a_surface' (pixel format, picture, etc.)
		local
			l_item:POINTER
		do
			clear_error
			l_item := {GAME_SDL_EXTERNAL}.SDL_CreateTextureFromSurface(
						a_for_window.renderer.item, a_surface.item)
			manage_error_pointer(l_item, "Cannot create texture.")
			make_by_pointer(l_item)
		ensure
			Error_Or_Exist: not has_error implies exists
		end

feature -- Access

 	width:INTEGER
			-- The horizontal length of `Current'
		require
			Texture_Exist: exists
		do
			Result := informations.width
		end

	height:INTEGER
			-- The vertical length of `Current'
		require
			Texture_Exist: exists
		do
			Result := informations.height
		end

	is_lockable:BOOLEAN
			-- Can `Current' be locked for modification
		require
			Texture_Exist: exists
		do
			Result := informations.access = {GAME_SDL_EXTERNAL}.SDL_TEXTUREACCESS_STREAMING
		end

	is_targetable:BOOLEAN
			-- Can `Current' be use as render target
		require
			Texture_Exist: exists
		do
			Result := informations.access = {GAME_SDL_EXTERNAL}.SDL_TEXTUREACCESS_TARGET
		end

	pixel_format:GAME_PIXEL_FORMAT_READABLE
			-- Informations about the internal representation of pixels in `Current'
		require
			Texture_Exist: exists
		do
			create Result.make_from_flags(informations.format)
		end

	additionnal_alpha:NATURAL_8 assign set_additionnal_alpha
			-- Additionnal alpha blend to apply on `Current' when drawing
		require
			Texture_Exist: exists
		local
			l_error:INTEGER
		do
			clear_error
			l_error := {GAME_SDL_EXTERNAL}.SDL_GetTextureAlphaMod(item, $Result)
			manage_error_code(l_error, "Cannot retreive the texture additionnal alpha value.")
		end

	set_additionnal_alpha(a_additionnal_alpha:NATURAL_8)
			-- Assign `additionnal_alpha' with the value of `a_additionnal_alpha'
		require
			Texture_Exist: exists
		local
			l_error:INTEGER
		do
			clear_error
			l_error := {GAME_SDL_EXTERNAL}.SDL_SetTextureAlphaMod(item, a_additionnal_alpha)
			manage_error_code(l_error, "Cannot set the texture additionnal alpha value")
		ensure
			Is_Set: additionnal_alpha = a_additionnal_alpha
		end

	additionnal_color:GAME_COLOR_READABLE assign set_additionnal_color
			-- Additionnal color to multiply to `Current' when drawing
		require
			Texture_Exist: exists
		local
			l_error:INTEGER
			l_red, l_green, l_blue:NATURAL_8
		do
			clear_error
			l_error := {GAME_SDL_EXTERNAL}.SDL_GetTextureColorMod(item, $l_red, $l_green, $l_blue)
			manage_error_code(l_error, "Cannot retreive the texture additionnal color value.")
			create Result.make_rgb(l_red, l_green, l_blue)
		end

	set_additionnal_color(a_additionnal_color:GAME_COLOR_READABLE)
			-- Assign `additionnal_color' with the value of `a_additionnal_color'
		require
			Texture_Exist: exists
		local
			l_error:INTEGER
		do
			clear_error
			l_error := {GAME_SDL_EXTERNAL}.SDL_SetTextureColorMod(item,
											a_additionnal_color.red,
											a_additionnal_color.green,
											a_additionnal_color.blue)
			manage_error_code(l_error, "Cannot set the texture additionnal alpha value")
		ensure
			Is_Set: additionnal_color ~ a_additionnal_color
		end

feature {NONE} -- Measurement

	structure_size: INTEGER_32
			-- <Precursor>
		do
			Result := 0
		end

feature {NONE} -- Implementation

	informations:TUPLE[format: NATURAL_32; access, width, height:INTEGER]
			-- Retreive the pixel `format', the `access' flag, the `width' and the `height' of `Current'
		require
			Texture_Exists: exists
		local
			l_format:NATURAL_32
			l_error, l_access, l_width, l_height:INTEGER
		do
			l_error := {GAME_SDL_EXTERNAL}.SDL_QueryTexture(item, $l_format,
						$l_access, $l_width, $l_height)
			manage_error_code(l_error, "Cannot retreive texture informations.")
			Result := [l_format, l_access, l_width, l_height]
		end

	dispose
			-- <Precursor>
		do
			if exists then
				{GAME_SDL_EXTERNAL}.SDL_DestroyTexture(item)
				create internal_item
			end
		end

feature {NONE} -- External

	c_get_blend_mode (a_item, a_blend_mode: POINTER): INTEGER_32
		do
			Result := {GAME_SDL_EXTERNAL}.SDL_GetTextureBlendMode(a_item, a_blend_mode)
		end

	c_set_blend_mode (a_item: POINTER; a_blend_mode: INTEGER_32): INTEGER_32
		do
			Result := {GAME_SDL_EXTERNAL}.SDL_SetTextureBlendMode(a_item, a_blend_mode)
		end

end
