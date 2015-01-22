note
	description : "Mouse-text application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
		local
			controller:GAME_LIB_CONTROLLER
			audio_ctrl:AUDIO_CONTROLLER
		do
			create controller.make
			create audio_ctrl.make
			controller.enable_video -- Enable the video functionalities
			audio_ctrl.enable_sound
			run_game(controller,audio_ctrl)  -- Run the core creator of the game.
			audio_ctrl.quit_library
			controller.quit_library  -- Clear the library before quitting
		end

	run_game(controller:GAME_LIB_CONTROLLER;audio_ctrl:AUDIO_CONTROLLER)
		local
			icon_trans_color:GAME_COLOR
		do
			controller.event_controller.on_quit_signal.extend (agent on_quit(controller))  -- When the X of the window is pressed, execute the on_quit method.
			create icon_trans_color.make_rgb(255,0,255)  -- Change the pink for transparent in the window icon.
			controller.create_screen_surface_with_icon ("icon.bmp", icon_trans_color, 324, 240, 16, true, true, false, true, false) -- Create the window. Dimension: 320x240,
										-- 16 bits per pixel, Use video memory, use hardware double buffer,
										-- the windows will be unresisable, the window will have the window frame, not in fullscreen mode.
										-- Use the file icon.bmp (must be a bmp file and must be 32x32 on Windows) for window icon
										-- To enable transparency, the "icon.bmp" file must have a 8 bits per pixels indexed image format.
			controller.set_window_caption ("Exemple Sound", "Sound")	-- Put a caption for the window and the icon (on some system)
			controller.event_controller.on_key_down.extend (agent on_key_down_quit(controller,?)) -- When the user press the escape key, close the application

			set_sound (controller,audio_ctrl)	-- Set the sound system to play the music and the sound on space key press

			controller.launch  -- The controller will loop until the stop controller.method is called (in method on_quit).
		end

	set_sound(controller:GAME_LIB_CONTROLLER;audio_ctrl:AUDIO_CONTROLLER)
		local
			l_sound,l_music_intro,l_music_loop:AUDIO_SOUND_SND_FILE
			sound_source,music_source:AUDIO_SOURCE	-- You need one source for each sound you want to be playing at the same time.
		do
			create l_sound.make ("sound.aif")			-- This sound will be played when the user press the space bar.
			create l_music_intro.make ("intro.ogg")		-- This sound will be played once at the begining of the music
			create l_music_loop.make ("loop.flac")		-- This sound will be loop until the application stop.
														-- The library can use every sound file format that the libsndfile library can use (see: http://www.mega-nerd.com/libsndfile)
			audio_ctrl.add_source
			music_source:=audio_ctrl.last_source	-- The first source will be use for playing the music
			audio_ctrl.add_source
			sound_source:=audio_ctrl.last_source	-- The second source will be use for playing the space sound

			music_source.queue_sound (l_music_intro)				-- Playing the intro first
			music_source.queue_sound_infinite_loop (l_music_loop)	-- After the intro end, loop the music loop

			controller.event_controller.on_key_down.extend (agent on_key_down_sound(l_sound,sound_source,?))	-- When a key is pressed, the on_key_down will be launch
																												-- The on_key_down routine will receive the sound and the source
																												-- Note that you can add more than one event routine for an event
			controller.event_controller.on_iteration.extend (agent audio_ctrl.update)	-- To be sure that the sound will auto update sources buffers. You can use the launch_in_thread
																					-- feature of the AUDIO_CONTROLLER instead, but your application must be multi-thread enable to do so.
			music_source.play	-- Play the music
		end

	on_key_down_quit(controller:GAME_LIB_CONTROLLER;kb_event:GAME_KEYBOARD_EVENT)
		do
			if kb_event.is_escape_key then			-- If the escape key as been pressed,
				controller.stop						-- quit the application
			end
		end

	on_key_down_sound(l_sound:AUDIO_SOUND;sound_source:AUDIO_SOURCE;kb_event:GAME_KEYBOARD_EVENT)
		do
			if kb_event.is_space_key then		-- If the space key as been pressed, play the space sound
				sound_source.stop					-- Assure that the queue buffer is empty on the sound_source object (when stop, the source queue is clear)
				l_sound.restart
				sound_source.queue_sound (l_sound)	-- Queud the sound into the source queue
				sound_source.play					-- Play the source
			end
		end

	on_quit(controller:GAME_LIB_CONTROLLER)
			-- This method is called when the quit signal is send to the application (ex: window X button pressed).
		do
			controller.stop  -- Stop the controller loop (allow controller.launch to return)
		end


end
