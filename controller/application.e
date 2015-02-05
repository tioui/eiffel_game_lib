note
	description: "Example of controllers (joystick) usage"
	generator: "EiffelBuild"
	author: "Louis Marchand"
	date: "2015-02-05"
	revision: "1.0"

class
	APPLICATION

inherit
	EV_APPLICATION
		redefine
			create_interface_objects,
			initialize
		end

create
	default_create, make_and_launch

feature {NONE} -- Initialization

	make_and_launch
			-- Create, initialize and launch event loop.
		do
			create game_library.make
			game_library.enable_joystick
			game_library.enable_video
			default_create
			launch
			main_window := Void
			game_library.quit_library
		end

feature {NONE} -- User Initialization

	user_create_interface_objects
			-- User object creation.
		do
				-- Create Window
			create main_window.make (game_library)
		end

	user_initialization
			-- User object initialization.
		do
				-- Show Window
			main_window.show
		end

feature -- Access

	main_window: SELECT_CONTROLLER_WINDOW
			-- Application Main Window.	

	game_library: GAME_LIB_CONTROLLER
			-- Controller for the game library

feature {NONE} -- Implementation

	frozen initialize
			-- <Precursor>
			-- Do not alter routine.
		do
			user_initialization
			Precursor
		end

	frozen create_interface_objects
			-- <Precursor>
			-- Do not alter routine.
		do
			user_create_interface_objects
			Precursor
		end

end
