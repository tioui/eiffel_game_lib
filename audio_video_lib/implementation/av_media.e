note
	description: "Summary description for {AV_MEDIA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AV_MEDIA

inherit
	AV_ANY

	DISPOSABLE


feature {NONE} -- Initialisation

	make(a_filename:STRING)
		local
			l_filename_c:C_STRING
			l_error:INTEGER
		do
			init_library
			create l_filename_c.make (a_filename)
			l_error:={AV_EXTERNAL}.avformat_open_input($format_context_pointer,l_filename_c.item,void_ptr.item,void_ptr.item)
			check l_error=0 end
			l_error:={AV_EXTERNAL}.avformat_find_stream_info(format_context_pointer,void_ptr.item)
			check l_error>=0 end
			create {ARRAYED_QUEUE[POINTER]} packets_pool.make(1)
			create {ARRAYED_QUEUE[POINTER]} packets_filled.make(1)
			test:=0
		end

	init_stream(a_flags:NATURAL_32):INTEGER
		local
			i:INTEGER
			l_is_found:BOOLEAN
			l_nb_stream:INTEGER
		do
			l_nb_stream:={AV_EXTERNAL}.get_av_format_context_struct_nb_streams(format_context_pointer).to_integer_32
			Result:=-1
			from
				i:=0
				l_is_found:=false
			until
				i>=l_nb_stream or
				l_is_found
			loop
				if {AV_EXTERNAL}.get_av_codec_context_struct_codec_type(context_pointer(i))=a_flags then
					l_is_found:=true
					Result:=i
				end
				i:=i+1
			end
		end

	open_codec(a_codec_context:POINTER)
		local
			l_codec_id:NATURAL
			l_codec_ptr:POINTER
			l_error:INTEGER
		do
			l_codec_id:={AV_EXTERNAL}.get_av_codec_context_struct_codec_id(a_codec_context)
			l_codec_ptr:={AV_EXTERNAL}.avcodec_find_decoder(l_codec_id)
			check not l_codec_ptr.is_default_pointer end
			l_error:={AV_EXTERNAL}.avcodec_open2(a_codec_context,l_codec_ptr,void_ptr)
			check l_error=0 end
		end

feature -- Access

	restart
			-- Restart the media to the beginning.
		local
			l_error:INTEGER
		do
			l_error:={AV_EXTERNAL}.av_seek_frame(format_context_pointer,-1,0,{AV_EXTERNAL}.AVSEEK_FLAG_ANY.bit_or ({AV_EXTERNAL}.AVSEEK_FLAG_BACKWARD))
			check l_error >= 0 end
			last_packet:=false
		end

feature {NONE} -- Implementation - Routines


	read_packet(a_index:INTEGER)
		local
			l_error:INTEGER
			l_got:BOOLEAN
		do
			from
				l_got:=false
				last_packet:=false
			until
				l_got or
				last_packet
			loop
				if packets_pool.is_empty then
					fill_packet_pool
				end
				{AV_EXTERNAL}.av_free_packet(packets_pool.item)
				test:=test+1
				l_error:={AV_EXTERNAL}.av_read_frame(format_context_pointer,packets_pool.item)
				if l_error<0 then
					if l_error/={AV_EXTERNAL}.AVERROR_EOF then
						io.error.put_string ("Error reading frame: "+get_error_Message(l_error)+"%N")
						check false end
					end
					last_packet:=true
				else
					if {AV_EXTERNAL}.get_av_packet_struct_stream_index(packets_pool.item)=a_index then
						packets_filled.put (packets_pool.item)
						packets_pool.remove
						l_got:=true
					end
				end
			end
		end

	fill_packet_pool
		local
			new_packet:POINTER
		do
			new_packet:={AV_EXTERNAL}.av_malloc({AV_EXTERNAL}.c_sizeof_av_packet)
			new_packet.memory_set (0, {AV_EXTERNAL}.c_sizeof_av_packet)
			packets_pool.put (new_packet)
		end


	close_codec(a_codec_context:POINTER)
		local
			l_error:INTEGER
		do
			l_error:={AV_EXTERNAL}.avcodec_close(a_codec_context)
			check l_error=0 end
		end

	context_pointer(a_index:INTEGER):POINTER
		local
			l_temp_stream:POINTER
		do
			l_temp_stream:={AV_EXTERNAL}.get_av_format_context_struct_streams_i(format_context_pointer,a_index)
			Result:={AV_EXTERNAL}.get_av_stream_struct_codec(l_temp_stream)
			check not Result.is_default_pointer end
		end

	dispose
		do
			from
			until
				packets_filled.is_empty
			loop
				{AV_EXTERNAL}.av_free(packets_filled.item)
				packets_filled.remove
			end
			from
			until
				packets_pool.is_empty
			loop
				{AV_EXTERNAL}.av_free(packets_pool.item)
				packets_pool.remove
			end
			{AV_EXTERNAL}.avformat_close_input($format_context_pointer)
		end

feature {NONE} -- Implementation - Variables

	format_context_pointer:POINTER
	last_packet:BOOLEAN
	packets_pool:QUEUE[POINTER]
	packets_filled:QUEUE[POINTER]

	is_thread_safe:BOOLEAN
	media_mutex:MUTEX

	test:NATURAL_64

invariant
	Media_Thread_Safe_Mutex_Set: (not is_thread_safe) or else media_mutex.is_set

end
