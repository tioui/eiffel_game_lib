note
	description: "{EV_FRAME} that is going to contain every {AXIS_WIDGET} for every axis on a joystick"
	generator: "EiffelBuild"
	author: "Louis Marchand"
	date: "2015-02-05"
	revision: "1.0"

class
	AXES_FRAME

inherit
	AXES_FRAME_IMP

create
	make

feature {NONE} -- Initialization

	make(a_joystick:GAME_JOYSTICK)
		do
			joystick := a_joystick
			default_create
		end

	user_create_interface_objects
			-- <Precursor>
		do
			create {ARRAYED_LIST[AXIS_WIDGET]} axis_widgets.make (joystick.get_axes_number)
		end

	user_initialization
			-- <Precursor>
		local
			i:INTEGER
		do
			from i := 1 until i >= joystick.get_axes_number loop
				axis_widgets.extend (create {AXIS_WIDGET}.make (i - 1))
				vb_container.extend (axis_widgets.last)
				i := i + 1
			end
		end

feature -- Access

	on_joystick_axis_change(a_value: INTEGER_16; a_axis_id:NATURAL_8)
		do
			if axis_widgets.valid_index (a_axis_id + 1) then
				axis_widgets.at (a_axis_id + 1).set_value (a_value)
			end
		end

feature {NONE} -- Implementation

	joystick:GAME_JOYSTICK

	axis_widgets:LIST[AXIS_WIDGET]

end
