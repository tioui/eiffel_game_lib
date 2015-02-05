note
	description: "{EV_FRAME} that is used to contain a vertical list of widget."
	author: "Louis Marchand"
	date: "2015-02-05"
	revision: "1.0"

deferred class
	LIST_FRAME

inherit
	LIST_FRAME_IMP


feature {NONE} -- Initialization

	make(a_joystick:GAME_JOYSTICK)
			-- Initialization of `Current' using `a_joystick' as `joystick'
		do
			joystick := a_joystick
			default_create
		end

feature {NONE} -- Implementation

	joystick:GAME_JOYSTICK
			-- The {GAME_JOYSTICK} associate with `Current'

end
