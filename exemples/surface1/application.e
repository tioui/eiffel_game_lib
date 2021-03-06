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
		do
			create controller.make
			controller.enable_video -- Enable the video functionalities
			run_game(controller)  -- Run the core creator of the game.
			controller.quit_library  -- Clear the library before quitting
		end

	run_game(controller:GAME_LIB_CONTROLLER)
		local
			bk,sprite1:GAME_SURFACE_BMP_FILE
		do
			controller.event_controller.on_quit_signal.extend (agent on_quit(controller))  -- When the X of the window is pressed, execute the on_quit method.

			create bk.make ("bk.bmp")  -- Create the background surface

			controller.create_screen_surface (bk.width, bk.height, 16, true, true, false, true, false)	-- Create the window. Dimension: same as bk image, 16 bits per pixel, Use video memory, use hardware double buffer,
																											-- the windows will be unresisable, the window will have the window frame, not in fullscreen mode.

			controller.screen_surface.draw_surface (bk, 0, 0)  -- Set the background image.

			create sprite1.make ("pingus.bmp")  -- This image don't have an Alpha chanel.
			sprite1.set_transparent_color (create {GAME_COLOR}.make_rgb(255,0,255))  -- We can use the set_transparent_color to select a color for the transparency (in this case, pink -> 255,0,255)
			sprite1.is_transparent_accelerated:=true
			controller.screen_surface.draw_surface (sprite1, 400, 350)  -- Put the sprite1 on the screen
			controller.flip_screen  -- Show the screen in the window.
			controller.launch  -- The controller will loop until the stop controller.method is called (in method on_quit).
		end

	on_quit(controller:GAME_LIB_CONTROLLER)
			-- This method is called when the quit signal is send to the application (ex: window X button pressed).
		do
			controller.stop  -- Stop the controller loop (allow controller.launch to return)
		end


end
