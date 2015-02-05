note
	description: "{EV_WINDOW} that show a joystick informations."
	generator: "EiffelBuild"
	author: "Louis Marchand"
	date: "2015-02-05"
	revision: "1.0"

class
	VIEW_CONTROLLER_WINDOW

inherit
	VIEW_CONTROLLER_WINDOW_IMP

create
	make

feature {NONE} -- Initialization

	make(a_game_library:GAME_LIB_CONTROLLER; a_joystick_index:INTEGER)
			-- Initialization of `Current' using `a_game_library' as `game_library'
			-- and `a_joystick_index' as `joystick_index'
		do
			joystick_index := a_joystick_index
			game_library := a_game_library
			default_create
		end

	user_create_interface_objects
			-- <Precursor>
		do
			create timer.make_with_interval (1)
			joystick := game_library.get_joystick (joystick_index)
		end

	user_initialization
			-- <Precursor>
		do
			lbl_controller_name.set_text(joystick.name)
			joystick.open
			initialize_axes
			initialize_buttons
			initialize_hats
			timer.actions.extend (agent game_library.update)
			game_library.create_screen_surface (1, 1, 8, False, False, False, False, False)
			game_library.event_controller.enable_joystick_event
		end

	initialize_axes
			-- Extract any axes of the `joystick' and represent it in a {AXES_FRAME}
		local
			l_axis_frame:AXES_FRAME
		do
			if joystick.get_axes_number > 0 then
				create l_axis_frame.make(joystick)
				vb_container.extend (l_axis_frame)
				game_library.event_controller.on_joystick_axis_change.extend (agent on_joystick_axis_change(l_axis_frame, ?, ?, ?))
			end
		end

	initialize_buttons
			-- Extract any buttons of the `joystick' and represent it in a {BUTTONS_FRAME}
		local
			l_buttons_frame:BUTTONS_FRAME
		do
			if joystick.get_buttons_number > 0 then
				create l_buttons_frame.make(joystick)
				vb_container.extend (l_buttons_frame)
				game_library.event_controller.on_joystick_button_pressed.extend (agent on_joystick_button_pressed(l_buttons_frame, ?, ?))
				game_library.event_controller.on_joystick_button_released.extend (agent on_joystick_button_released(l_buttons_frame, ?, ?))
			end
		end

	initialize_hats
			-- Extract any hats of the `joystick' and represent it in a {HATS_FRAME}
		local
			l_hats_frame:HATS_FRAME
		do
			if joystick.get_hats_number > 0 then
				create l_hats_frame.make(joystick)
				vb_container.extend (l_hats_frame)
				game_library.event_controller.on_joystick_hats_change.extend (agent on_joystick_hats_change(l_hats_frame, ?, ?, ?, ?, ?, ?))
			end
		end

feature -- Access

	on_joystick_axis_change(a_axis_frame:AXES_FRAME; a_value: INTEGER_16; a_axis_id, a_device_id: NATURAL_8)
			-- Action to launch when a `joystick' axis state has been modified.
		do
			if a_device_id.as_integer_32 = joystick_index then
				a_axis_frame.on_joystick_axis_change (a_value, a_axis_id)
			end
		end

	on_joystick_button_pressed(a_buttons_frame:BUTTONS_FRAME; a_button_id, a_device_id: NATURAL_8)
			-- Action to launch when a `joystick' button has been pressed.
		do
			if a_device_id.as_integer_32 = joystick_index then
				a_buttons_frame.on_joystick_button_pressed (a_button_id)
			end
		end

	on_joystick_button_released(a_buttons_frame:BUTTONS_FRAME; a_button_id, a_device_id: NATURAL_8)
			-- Action to launch when a `joystick' button has been released.
		do
			if a_device_id.as_integer_32 = joystick_index then
				a_buttons_frame.on_joystick_button_released (a_button_id)
			end
		end

	on_joystick_hats_change(a_hats_frame:HATS_FRAME; a_is_up, a_is_down, a_is_left, a_is_right: BOOLEAN; a_hat_id, a_device_id: NATURAL_8)
			-- Action to launch when a `joystick' hats state has been modified.
		do
			if a_device_id.as_integer_32 = joystick_index then
				a_hats_frame.on_joystick_hats_change(a_is_up, a_is_down, a_is_left, a_is_right, a_hat_id)
			end
		end

feature {NONE} -- Implementation

	joystick:GAME_JOYSTICK
			-- The {GAME_JOYSTICK} to shoed information in `Current'

	joystick_index:INTEGER
			-- The internal index of the `joystick'

	game_library:GAME_LIB_CONTROLLER
			-- Controller for the game library

	timer:EV_TIMEOUT
			-- Used to update the events in the `game_library'

end
