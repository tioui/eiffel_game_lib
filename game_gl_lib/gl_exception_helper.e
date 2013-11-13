note
	description: "Summary description for {GL_EXCEPTION_HELPER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GL_EXCEPTION_HELPER

feature -- Access

	has_error:BOOLEAN

	clear_error
		do
			has_error:=false
		end

feature {NONE} -- Implementation

	check_for_error
		local
			l_error_code:INTEGER_32
			l_exception:GL_EXCEPTION
		do
			l_error_code:={GL_GL_EXTERNAL}.glGetError
			if l_error_code /= {GL_GL_EXTERNAL}.GL_NO_ERROR then
				has_error:=true
				create l_exception.make(l_error_code)
				l_exception.raise
			end
		end
end
