note
	description: "Summary description for {GL2D_SDL_EXTERNAL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GL_SDL_EXTERNAL

feature -- Functions SDL.h

	frozen SDL_GL_SetAttribute(attr:INTEGER_32;value:INTEGER):INTEGER
		external
			"C (SDL_GLattr,int):int | <SDL.h>"
		alias
			"SDL_GL_SetAttribute"
		end

	frozen SDL_GL_SwapBuffers
		external
			"C | <SDL.h>"
		alias
			"SDL_GL_SwapBuffers"
		end

feature -- Constants SDL.h

	frozen SDL_OPENGL:NATURAL_32
		external
			"C inline use <SDL.h>"
		alias
			"SDL_OPENGL"
		end

	frozen SDL_OPENGLBLIT:NATURAL_32
		external
			"C inline use <SDL.h>"
		alias
			"SDL_OPENGLBLIT"
		end

	frozen SDL_GL_DOUBLEBUFFER:INTEGER_32
		external
			"C inline use <SDL.h>"
		alias
			"SDL_GL_DOUBLEBUFFER"
		end

	frozen SDL_GL_DEPTH_SIZE:INTEGER_32
		external
			"C inline use <SDL.h>"
		alias
			"SDL_GL_DEPTH_SIZE"
		end

end
