note
	description: "{EV_WIDGET} that visualy represent a joystick axis value."
	generator: "EiffelBuild"
	author: "Louis Marchand"
	date: "2015-02-05"
	revision: "1.0"

class
	AXIS_WIDGET

inherit
	AXIS_WIDGET_IMP

create
	make

feature {NONE} -- Initialization

	make(a_axis_index:INTEGER)
			-- Initialization of `Current' using `a_axis_index' as `axis_index'
		do
			axis_index := a_axis_index
			default_create
		end

	user_initialization
			-- <Precursor>
		do
			lbl_name.set_text (axis_index.out)
			hr_slide.set_value(hr_slide.value_range.lower)
		end

feature -- Access

	axis_index:INTEGER
			-- The internal index of the axis on the device

	value:INTEGER assign set_value
			-- The value that `Current' is presently showing
		do
			Result := hr_slide.value
		end

	set_value(a_value:INTEGER)
			-- Make `Current' showed `a_value'
		do
			hr_slide.set_value (a_value)
		end

end
