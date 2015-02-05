note
	description: "{EV_WINDOW} that ask the use to select a joystick in a list."
	generator: "EiffelBuild"
	author: "Louis Marchand"
	date: "2015-02-05"
	revision: "1.0"

class
	SELECT_CONTROLLER_WINDOW

inherit
	SELECT_CONTROLLER_WINDOW_IMP

create
	make

feature {NONE} -- Initialization

	make(a_game_library:GAME_LIB_CONTROLLER)
			-- Initialization of `Current' using `a_game_library' as `game_library'
		do
			game_library := a_game_library
			default_create
		end

	user_initialization
			-- <Precursor>
		local
			l_no_controller_dialog:EV_INFORMATION_DIALOG
			i:INTEGER
			l_item:EV_LIST_ITEM
		do
			if game_library.get_joystick_count > 0 then
				from i := 0 until i >= game_library.get_joystick_count loop
					create l_item.make_with_text (game_library.get_joystick (i).name)
					lst_controllers.extend (l_item)
					i := i + 1
				end
			else
				create l_no_controller_dialog.make_with_text ("No controller found!")
				l_no_controller_dialog.show_modal_to_window (Current)
			end
		end

feature {NONE} -- Implementation

	btn_ok_on_key_pressed
			-- <Precursor>
		local
			i:INTEGER
			l_view_window:VIEW_CONTROLLER_WINDOW
			l_no_selected_dialog:EV_INFORMATION_DIALOG
		do
			if attached lst_controllers.selected_item then
				from
					i := 0
				until
					i >= game_library.get_joystick_count or
					game_library.get_joystick (i).name.is_equal (lst_controllers.selected_item.text.to_string_8)
				loop
					i := i + 1
				end
				if game_library.get_joystick (i).name.is_equal (lst_controllers.selected_item.text.to_string_8) then
					create l_view_window.make(game_library, i)
					l_view_window.show
				end
			else
				create l_no_selected_dialog.make_with_text ("Please select a controller.")
				l_no_selected_dialog.show_modal_to_window (Current)
			end
		end

	game_library:GAME_LIB_CONTROLLER
			-- Controller for the game library


end
