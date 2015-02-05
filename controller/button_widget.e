note
	description: "{EV_WIDGET} that visualy represent a joystick button state."
	generator: "EiffelBuild"
	author: "Louis Marchand"
	date: "2015-02-05"
	revision: "1.0"

class
	BUTTON_WIDGET

inherit
	BUTTON_WIDGET_IMP

create
	make

feature {NONE} -- Initialization

	make(a_button_index:INTEGER)
			-- Initialization of `Current' using `a_button_index' as `button_index'
		do
			button_index := a_button_index
			default_create
		end

	user_initialization
			-- Perform any initialization on objects created by `user_create_interface_objects'
			-- and from within current class itself.
		do
			lbl_button_name.set_text (button_index.out)
		end

feature -- Access

	activate
			-- To use when `Current' is pressed
		do
			cb_is_pressed.enable_select
		end

	desactivate
			-- To use when `Current' is released
		do
			cb_is_pressed.disable_select
		end

	is_activated:BOOLEAN
			-- Is `Current' is presently activated
		do
			Result := cb_is_pressed.is_selected
		end

	button_index:INTEGER
			-- The internal index of the button on the device


end
