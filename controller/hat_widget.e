note
	description: "{EV_WIDGET} that visualy represent a joystick hat state."
	generator: "EiffelBuild"
	author: "Louis Marchand"
	date: "2015-02-05"
	revision: "1.0"

class
	HAT_WIDGET

inherit
	HAT_WIDGET_IMP

create
	make

feature {NONE} -- Initialization

	make(a_hat_index:INTEGER)
			-- Initialization of `Current' using `a_hat_index' as `hat_index'
		do
			hat_index := a_hat_index
		end

	user_initialization
			-- <Precursor>
		do
				lbl_number.set_text (hat_index.out)
		end

feature -- Access

	hat_index:INTEGER
			-- The internal index of the hat on the device

	enable_up
			-- To use when the associate hat is moved up
		do
			cb_top.enable_select
		end

	disable_up
			-- To use when the associate hat is not moved up
		do
			cb_top.disable_select
		end

	enable_down
			-- To use when the associate hat is moved down
		do
			cb_bottom.enable_select
		end

	disable_down
			-- To use when the associate hat is not moved down
		do
			cb_bottom.disable_select
		end

	enable_left
			-- To use when the associate hat is moved left
		do
			cb_left.enable_select
		end

	disable_left
			-- To use when the associate hat is not moved left
		do
			cb_left.disable_select
		end

	enable_right
			-- To use when the associate hat is moved right
		do
			cb_right.enable_select
		end

	disable_right
			-- To use when the associate hat is not moved right
		do
			cb_right.disable_select
		end


end
