note
	description: "Summary description for {GL_EXCEPTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GL_EXCEPTION

inherit
	DEVELOPER_EXCEPTION

create
	make

feature {NONE} -- Implementation

	make(a_code:INTEGER_32)
		do
			if a_code.bit_and ({GL_GL_EXTERNAL}.GL_INVALID_ENUM) ={GL_GL_EXTERNAL}.GL_INVALID_ENUM then
				set_description ("An unacceptable value is specified for an enumerated argument.")
			elseif a_code.bit_and ({GL_GL_EXTERNAL}.GL_INVALID_VALUE) ={GL_GL_EXTERNAL}.GL_INVALID_VALUE then
				set_description ("A numeric argument is out of range.")
			elseif a_code.bit_and ({GL_GL_EXTERNAL}.GL_INVALID_OPERATION) ={GL_GL_EXTERNAL}.GL_INVALID_OPERATION then
				set_description ("The specified operation is not allowed in the current state.")
			elseif a_code.bit_and ({GL_GL_EXTERNAL}.GL_INVALID_FRAMEBUFFER_OPERATION) ={GL_GL_EXTERNAL}.GL_INVALID_FRAMEBUFFER_OPERATION then
				set_description ("The framebuffer object is not complete.")
			elseif a_code.bit_and ({GL_GL_EXTERNAL}.GL_OUT_OF_MEMORY) ={GL_GL_EXTERNAL}.GL_OUT_OF_MEMORY then
				set_description ("There is not enough memory left to execute the command.")
			elseif a_code.bit_and ({GL_GL_EXTERNAL}.GL_STACK_UNDERFLOW) ={GL_GL_EXTERNAL}.GL_STACK_UNDERFLOW then
				set_description ("An attempt has been made to perform an operation that would cause an internal stack to underflow.")
			elseif a_code.bit_and ({GL_GL_EXTERNAL}.GL_STACK_OVERFLOW) ={GL_GL_EXTERNAL}.GL_STACK_OVERFLOW then
				set_description ("An attempt has been made to perform an operation that would cause an internal stack to overflow.")
			end
		end


end
