note
	description: "Summary description for {HATS_FRAME}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HATS_FRAME

inherit
	LIST_FRAME

create
	make

feature {NONE} -- Initialization

	user_create_interface_objects
			-- <Precursor>
		do
			create {ARRAYED_LIST[HAT_WIDGET]} hats_widgets.make (joystick.get_hats_number)
		end

	user_initialization
			-- <Precursor>
		local
			i:INTEGER
		do
			from i := 1 until i >= joystick.get_hats_number loop
				hats_widgets.extend (create {HAT_WIDGET}.make (i - 1))
				hb_container.extend (hats_widgets.last)
				i := i + 1
			end
		end

feature -- Access

	on_joystick_hats_change(a_is_up, a_is_down, a_is_left, a_is_right: BOOLEAN; a_hat_id: NATURAL_8)
			-- Action to launch when a hat state has been modified on the `joystick'
		do
			if hats_widgets.valid_index (a_hat_id + 1) then
				if a_is_up then
					hats_widgets.at (a_hat_id + 1).enable_up
				else
					hats_widgets.at (a_hat_id + 1).disable_up
				end
				if a_is_down then
					hats_widgets.at (a_hat_id + 1).enable_down
				else
					hats_widgets.at (a_hat_id + 1).disable_down
				end
				if a_is_left then
					hats_widgets.at (a_hat_id + 1).enable_left
				else
					hats_widgets.at (a_hat_id + 1).disable_left
				end
				if a_is_right then
					hats_widgets.at (a_hat_id + 1).enable_right
				else
					hats_widgets.at (a_hat_id + 1).disable_right
				end
			end
		end

feature {NONE} -- Implementation

	hats_widgets:LIST[HAT_WIDGET]
			-- Every hat widget associated to every hat of the `joystick'


end
