note
	description: "{EV_FRAME} that is going to contain every {BUTTON_WIDGET} for every button on a joystick"
	generator: "EiffelBuild"
	author: "Louis Marchand"
	date: "2015-02-05"
	revision: "1.0"

class
	BUTTONS_FRAME

inherit
	LIST_FRAME

create
	make

feature {NONE} -- Initialization

	user_create_interface_objects
			-- <Precursor>
		do
			create {ARRAYED_LIST[BUTTON_WIDGET]} buttons_widgets.make (joystick.get_buttons_number)
		end

	user_initialization
			-- <Precursor>
		local
			i:INTEGER
		do
			from i := 1 until i >= joystick.get_buttons_number loop
				buttons_widgets.extend (create {BUTTON_WIDGET}.make (i - 1))
				hb_container.extend (buttons_widgets.last)
				i := i + 1
			end
		end

feature -- Access

	on_joystick_button_pressed(a_button_id: NATURAL_8)
			-- Action to launch when a button has been pressed on the `joystick'
		do
			if buttons_widgets.valid_index (a_button_id + 1) then
				buttons_widgets.at (a_button_id + 1).activate
			end
		end

	on_joystick_button_released(a_button_id: NATURAL_8)
			-- Action to launch when a button has been released on the `joystick'
		do
			if buttons_widgets.valid_index (a_button_id + 1) then
				buttons_widgets.at (a_button_id + 1).desactivate
			end
		end

feature {NONE} -- Implementation

	buttons_widgets:LIST[BUTTON_WIDGET]
			-- Every button widget associated to every button of the `joystick'

end
