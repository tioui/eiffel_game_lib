note
	description: "Summary description for {GL2D_GL_EXTERNAL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GL_GL_EXTERNAL


feature -- Function gl.h

	frozen glClear(attr:NATURAL_32)
		external
			"C (GLbitfield) | <GL/gl.h>"
		alias
			"glClear"
		end

	frozen glBegin(mode:NATURAL_32)
		external
			"C (GLenum) | <GL/gl.h>"
		alias
			"glBegin"
		end

	frozen glEnd
		external
			"C | <GL/gl.h>"
		alias
			"glEnd"
		end

	frozen glFlush
		external
			"C | <GL/gl.h>"
		alias
			"glFlush"
		end

	frozen glFinish
		external
			"C | <GL/gl.h>"
		alias
			"glFinish"
		end

	frozen glColor3ub(red, green, blue:NATURAL_8)
		external
			"C (GLubyte, GLubyte, GLubyte) | <GL/gl.h>"
		alias
			"glColor3ub"
		end

	frozen glColor4ub(red, green, blue, alpha:NATURAL_8)
		external
			"C (GLubyte, GLubyte, GLubyte, GLubyte) | <GL/gl.h>"
		alias
			"glColor4ub"
		end

	frozen glVertex2d(x, y:REAL_64)
		external
			"C (GLdouble, GLdouble) | <GL/gl.h>"
		alias
			"glVertex2d"
		end

	frozen glVertex3d(x, y, z:REAL_64)
		external
			"C (GLdouble, GLdouble, GLdouble) | <GL/gl.h>"
		alias
			"glVertex3d"
		end

	frozen glPointSize(size:REAL_32)
		external
			"C (GLfloat) | <GL/gl.h>"
		alias
			"glPointSize"
		end

	frozen glGetFloatv(pname:INTEGER_32;params:POINTER)
		external
			"C (GLenum, GLfloat *) | <GL/gl.h>"
		alias
			"glGetFloatv"
		end

	frozen glGetError:INTEGER_32
		external
			"C : GLenum | <GL/gl.h>"
		alias
			"glGetError"
		end

	frozen glEnable(cap:INTEGER_32)
		external
			"C (GLenum) | <GL/gl.h>"
		alias
			"glEnable"
		end

	frozen glDisable(cap:INTEGER_32)
		external
			"C (GLenum) | <GL/gl.h>"
		alias
			"glDisable"
		end

	frozen glLineStipple(factor:INTEGER; pattern:NATURAL_16)
		external
			"C (GLint, GLushort) | <GL/gl.h>"
		alias
			"glLineStipple"
		end

	frozen glLineWidth(width:REAL_32)
		external
			"C (GLfloat) | <GL/gl.h>"
		alias
			"glLineWidth"
		end

	frozen glPolygonMode(face, mode:INTEGER_32)
		external
			"C (GLenum, GLenum) | <GL/gl.h>"
		alias
			"glPolygonMode"
		end

	frozen glFrontFace(mode:INTEGER_32)
		external
			"C (GLenum) | <GL/gl.h>"
		alias
			"glFrontFace"
		end

	frozen glCullFace(mode:INTEGER_32)
		external
			"C (GLenum) | <GL/gl.h>"
		alias
			"glCullFace"
		end

feature -- Constants gl.h

	frozen GL_COLOR_BUFFER_BIT:NATURAL_32
		external
			"C macro use <GL/gl.h>"
		alias
			"GL_COLOR_BUFFER_BIT"
		end

	frozen GL_DEPTH_BUFFER_BIT:NATURAL_32
		external
			"C macro use <GL/gl.h>"
		alias
			"GL_DEPTH_BUFFER_BIT"
		end

	frozen GL_STENCIL_BUFFER_BIT:NATURAL_32
		external
			"C macro use <GL/gl.h>"
		alias
			"GL_STENCIL_BUFFER_BIT"
		end

	frozen GL_POINTS:NATURAL_32
		external
			"C macro use <GL/gl.h>"
		alias
			"GL_POINTS"
		end

	frozen GL_LINES:NATURAL_32
		external
			"C macro use <GL/gl.h>"
		alias
			"GL_LINES"
		end

	frozen GL_LINE_STRIP:NATURAL_32
		external
			"C macro use <GL/gl.h>"
		alias
			"GL_LINE_STRIP"
		end

	frozen GL_LINE_LOOP:NATURAL_32
		external
			"C macro use <GL/gl.h>"
		alias
			"GL_LINE_LOOP"
		end

	frozen GL_TRIANGLES:NATURAL_32
		external
			"C macro use <GL/gl.h>"
		alias
			"GL_TRIANGLES"
		end

	frozen GL_TRIANGLE_STRIP:NATURAL_32
		external
			"C macro use <GL/gl.h>"
		alias
			"GL_TRIANGLE_STRIP"
		end

	frozen GL_TRIANGLE_FAN:NATURAL_32
		external
			"C macro use <GL/gl.h>"
		alias
			"GL_TRIANGLE_FAN"
		end

	frozen GL_QUADS:NATURAL_32
		external
			"C macro use <GL/gl.h>"
		alias
			"GL_QUADS"
		end

	frozen GL_QUAD_STRIP:NATURAL_32
		external
			"C macro use <GL/gl.h>"
		alias
			"GL_QUAD_STRIP"
		end

	frozen GL_POLYGON:NATURAL_32
		external
			"C macro use <GL/gl.h>"
		alias
			"GL_POLYGON"
		end

	frozen GL_POINT_SIZE_MIN:INTEGER_32
		external
			"C macro use <GL/gl.h>"
		alias
			"GL_POINT_SIZE_MIN"
		end

	frozen GL_POINT_SIZE_MAX:INTEGER_32
		external
			"C macro use <GL/gl.h>"
		alias
			"GL_POINT_SIZE_MAX"
		end

	frozen GL_NO_ERROR:INTEGER_32
		external
			"C macro use <GL/gl.h>"
		alias
			"GL_NO_ERROR"
		end

	frozen GL_INVALID_ENUM:INTEGER_32
		external
			"C macro use <GL/gl.h>"
		alias
			"GL_INVALID_ENUM"
		end

	frozen GL_INVALID_VALUE:INTEGER_32
		external
			"C macro use <GL/gl.h>"
		alias
			"GL_INVALID_VALUE"
		end

	frozen GL_INVALID_OPERATION:INTEGER_32
		external
			"C macro use <GL/gl.h>"
		alias
			"GL_INVALID_OPERATION"
		end

	frozen GL_INVALID_FRAMEBUFFER_OPERATION:INTEGER_32
		external
			"C macro use <GL/gl.h>"
		alias
			"GL_INVALID_FRAMEBUFFER_OPERATION"
		end

	frozen GL_OUT_OF_MEMORY:INTEGER_32
		external
			"C macro use <GL/gl.h>"
		alias
			"GL_OUT_OF_MEMORY"
		end

	frozen GL_STACK_UNDERFLOW:INTEGER_32
		external
			"C macro use <GL/gl.h>"
		alias
			"GL_STACK_UNDERFLOW"
		end

	frozen GL_STACK_OVERFLOW:INTEGER_32
		external
			"C macro use <GL/gl.h>"
		alias
			"GL_STACK_OVERFLOW"
		end

	frozen GL_LINE_WIDTH_RANGE:INTEGER_32
		external
			"C macro use <GL/gl.h>"
		alias
			"GL_LINE_WIDTH_RANGE"
		end

	frozen GL_LINE_STIPPLE:INTEGER_32
		external
			"C macro use <GL/gl.h>"
		alias
			"GL_LINE_STIPPLE"
		end

	frozen GL_FRONT_AND_BACK:INTEGER_32
		external
			"C macro use <GL/gl.h>"
		alias
			"GL_FRONT_AND_BACK"
		end

	frozen GL_FRONT:INTEGER_32
		external
			"C macro use <GL/gl.h>"
		alias
			"GL_FRONT"
		end

	frozen GL_BACK:INTEGER_32
		external
			"C macro use <GL/gl.h>"
		alias
			"GL_BACK"
		end

	frozen GL_POINT:INTEGER_32
		external
			"C macro use <GL/gl.h>"
		alias
			"GL_POINT"
		end

	frozen GL_LINE:INTEGER_32
		external
			"C macro use <GL/gl.h>"
		alias
			"GL_LINE"
		end

	frozen GL_FILL:INTEGER_32
		external
			"C macro use <GL/gl.h>"
		alias
			"GL_FILL"
		end

	frozen GL_CW:INTEGER_32
		external
			"C macro use <GL/gl.h>"
		alias
			"GL_CW"
		end

	frozen GL_CCW:INTEGER_32
		external
			"C macro use <GL/gl.h>"
		alias
			"GL_CCW"
		end

	frozen GL_CULL_FACE:INTEGER_32
		external
			"C macro use <GL/gl.h>"
		alias
			"GL_CULL_FACE"
		end

end
