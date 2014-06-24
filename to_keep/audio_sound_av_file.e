note
	description: "Load a file indo a GAME_AL_SOUND object."
	author: "Louis Marchand"
	date: "May 24, 2012"
	revision: "0.1"

class
	AUDIO_SOUND_AV_FILE

inherit
	AV_MEDIA
	redefine
		make,
		dispose
	end
	AUDIO_SOUND

create
	make,
	make_thread_safe

feature {NONE} -- Initialization

	make(a_filename:STRING)
			-- Initialization for `Current'.
		local
			l_error:INTEGER
		do
			precursor(a_filename)
			frame:={AV_EXTERNAL}.avcodec_alloc_frame
			check not frame.is_default_pointer end
			stream_index:=init_stream({AV_EXTERNAL}.AVMEDIA_TYPE_AUDIO)
			codec_context_ptr:=context_pointer(stream_index)
			frequency_internal:={AV_EXTERNAL}.get_av_codec_context_struct_sample_rate(codec_context_ptr)
			channel_count_internal:={AV_EXTERNAL}.get_av_codec_context_struct_channels(codec_context_ptr)
			fmt:={AV_EXTERNAL}.get_av_codec_context_struct_sample_fmt(codec_context_ptr)
			is_resampling:=false
			if fmt={AV_EXTERNAL}.AV_SAMPLE_FMT_U8 then
				bits_per_sample_internal:=8
				is_signed_internal:=false
			else
				bits_per_sample_internal:=16
				is_signed_internal:=true
				if fmt /={AV_EXTERNAL}.AV_SAMPLE_FMT_S16 then
					is_resampling:=true


					sample_context_ptr := {AV_EXTERNAL}.avresample_alloc_context();

					{AV_EXTERNAL}.av_opt_set_int(sample_context_ptr, (create {C_STRING}.make ("in_channel_layout")).item, channel_count_internal, 0);
					{AV_EXTERNAL}.av_opt_set_int(sample_context_ptr, (create {C_STRING}.make ("out_channel_layout")).item, channel_count_internal, 0);
					{AV_EXTERNAL}.av_opt_set_int(sample_context_ptr, (create {C_STRING}.make ("in_sample_rate")).item, frequency_internal, 0);
					{AV_EXTERNAL}.av_opt_set_int(sample_context_ptr, (create {C_STRING}.make ("out_sample_rate")).item, frequency_internal, 0);
					{AV_EXTERNAL}.av_opt_set_int(sample_context_ptr, (create {C_STRING}.make ("in_sample_fmt")).item, fmt, 0);
					{AV_EXTERNAL}.av_opt_set_int(sample_context_ptr, (create {C_STRING}.make ("out_sample_fmt")).item, {AV_EXTERNAL}.AV_SAMPLE_FMT_S16, 0);

					l_error := {AV_EXTERNAL}.avresample_open(sample_context_ptr)

					check Resample_Context_Openned: l_error=0 end

--					sample_context_ptr:={AV_EXTERNAL}.av_audio_resample_init(channel_count_internal,channel_count_internal,frequency_internal,frequency_internal,
--															{AV_EXTERNAL}.AV_SAMPLE_FMT_S16,fmt,0,0,0,1.0)
				end
			end
			open_codec(codec_context_ptr)
			side_buffer_count:=0
			side_buffer_size:=0
		end

	make_thread_safe(a_filename:STRING)
		do
			make(a_filename)
			is_thread_safe:=true
			create media_mutex.make
		end

feature {GAME_AUDIO_SOURCE}



	update_frame
		local
			l_got, l_error:INTEGER
			l_temp_packet:POINTER
		do
			from
				l_got:=0
			until
				last_packet or
				(l_got/=0 and {AV_EXTERNAL}.get_av_frame_struct_nb_samples(frame) > 0)

			loop
				if packets_filled.is_empty then
					read_packet(stream_index)
				else
					l_temp_packet:=packets_filled.item
					packets_filled.remove
					{AV_EXTERNAL}.avcodec_get_frame_defaults(frame)
					l_error:={AV_EXTERNAL}.avcodec_decode_audio4(codec_context_ptr,frame,$l_got,l_temp_packet)
					packets_pool.put (l_temp_packet)
				end
			end
			got_frame := l_got /= 0
		end

	number_of_sample_for_current_frame:INTEGER
		local
			l_available, l_delayed, l_frame_sample:INTEGER
		do
			l_available := {AV_EXTERNAL}.avresample_available(sample_context_ptr)
			l_delayed := {AV_EXTERNAL}.avresample_get_delay(sample_context_ptr)
			l_frame_sample := {AV_EXTERNAL}.get_av_frame_struct_nb_samples(frame)
			result := l_available + l_delayed + l_frame_sample
		end

	fill_side_buffer_from_ressampling
		local
			l_count, l_nb_sample, l_error:INTEGER
		do
			update_frame
			if got_frame then
				--l_nb_sample := {AV_EXTERNAL}.avresample_get_out_samples(sample_context_ptr, {AV_EXTERNAL}.get_av_frame_struct_nb_samples(frame))
				l_nb_sample := number_of_sample_for_current_frame
				side_buffer_count:={AV_EXTERNAL}.av_samples_get_buffer_size(create {POINTER},channel_count_internal,
					l_nb_sample, {AV_EXTERNAL}.AV_SAMPLE_FMT_S16,0)
				if side_buffer_count>side_buffer_size then
					if not side_buffer_internal.is_default_pointer then
						{AV_EXTERNAL}.av_freep($side_buffer_internal)
					end
					l_error := {AV_EXTERNAL}.av_samples_alloc($side_buffer_internal, $side_buffer_linesize, channel_count_internal,
							l_nb_sample, {AV_EXTERNAL}.AV_SAMPLE_FMT_S16, 0)
				end
				if l_error < 0 then
					side_buffer_count:=l_error
				end
				if side_buffer_count<0 then
					io.error.put_string ("Error reading packet: "+get_error_Message(side_buffer_count)+"%N")
					check Buffer_Size_Not_Valid: false end
					create side_buffer_internal
					side_buffer_count := 0
					side_buffer_size:=0
				else
					side_buffer_size := side_buffer_count
					side_buffer_count := {AV_EXTERNAL}.avresample_convert(sample_context_ptr, $side_buffer_internal, side_buffer_linesize, l_nb_sample,
						{AV_EXTERNAL}.get_av_frame_struct_extended_data_i(frame,0), 0, {AV_EXTERNAL}.get_av_frame_struct_nb_samples(frame))
				end
			end
		end

	fill_side_buffer
		local
			l_ending:BOOLEAN
			l_temp_packet:POINTER
			l_got:INTEGER
		do
			if is_resampling then
				fill_side_buffer_from_ressampling
			else
				update_frame
				if got_frame then
					side_buffer_count:={AV_EXTERNAL}.av_samples_get_buffer_size(create {POINTER},channel_count_internal,
							{AV_EXTERNAL}.get_av_frame_struct_nb_samples(frame),fmt,1)
					if side_buffer_count<0 then
						io.error.put_string ("Error reading packet: "+get_error_Message(side_buffer_count)+"%N")
						check Buffer_Size_Not_Valid: false end
						side_buffer_count:=0
						create side_buffer_internal
					else
						side_buffer_internal := {AV_EXTERNAL}.get_av_frame_struct_extended_data_i(frame,0)
					end
				else
					create side_buffer_internal
					side_buffer_count:=0
				end
				side_buffer_size:=side_buffer_count
			end
			side_buffer := side_buffer_internal
		end


	move_data_from_side_buffer_to_buffer(a_buffer:POINTER; a_offset:INTEGER)
		do
			a_buffer.memory_copy (side_buffer, a_offset)
			side_buffer := side_buffer.plus (a_offset)
			side_buffer_count := side_buffer_count - a_offset
		end

	fill_buffer_iteration(a_buffer:POINTER; a_max_lenght:INTEGER)
		local
			l_offset:INTEGER
		do
			if side_buffer_count<=0 then
				fill_side_buffer
			end
			if side_buffer_count > 0 then
				if side_buffer_count>a_max_lenght then
					move_data_from_side_buffer_to_buffer(a_buffer, a_max_lenght)
				else
					l_offset := side_buffer_count
					move_data_from_side_buffer_to_buffer(a_buffer, l_offset)
					fill_side_buffer
					fill_buffer_iteration(a_buffer.plus (l_offset), a_max_lenght-l_offset)
				end
			end

		end

	fill_buffer(a_buffer:POINTER; a_max_lenght:INTEGER)
		local
			l_ending:BOOLEAN
			l_temp_buffer:POINTER
			l_temp_packet:POINTER
		do
			if is_thread_safe then
				media_mutex.lock
			end
			fill_buffer_iteration(a_buffer, a_max_lenght)
			if is_thread_safe then
				media_mutex.unlock
			end
		end

--	fill_buffer1(a_buffer:POINTER;a_max_length:INTEGER)
--		local
--			l_error:INTEGER
--			l_ending:BOOLEAN
--			l_got,l_count, l_nb_sample:INTEGER
--			l_temp_buffer:POINTER
--			l_temp_packet:POINTER
--		do
--			if is_thread_safe then
--				media_mutex.lock
--			end
--			check side_buffer_count>=0 end
--			if side_buffer_count>0 then
--				a_buffer.memory_copy (side_buffer, side_buffer_count)
--			end
--			l_temp_buffer:=a_buffer.plus (side_buffer_count)
--			last_buffer_size:=side_buffer_count
--			side_buffer_count:=0
--			from
--				l_ending:=false
--			until
--				l_ending
--			loop
--				if packets_filled.is_empty then
--					read_packet(stream_index)
--					l_ending:=last_packet
--				end
--				if not l_ending then
--					l_temp_packet:=packets_filled.item
--					packets_filled.remove
--					packets_pool.put (l_temp_packet)
--					l_error:={AV_EXTERNAL}.avcodec_decode_audio4(codec_context_ptr,frame,$l_got,l_temp_packet)
--					if l_got/=0 then
--						if is_resampling then
--							l_nb_sample := {AV_EXTERNAL}.avresample_get_out_samples(sample_context_ptr, {AV_EXTERNAL}.get_av_frame_struct_nb_samples(frame))
--							l_count:={AV_EXTERNAL}.av_samples_get_buffer_size(create {POINTER},channel_count_internal,
--								l_nb_sample, {AV_EXTERNAL}.AV_SAMPLE_FMT_S16,1)
--							if l_count<0 then
--								io.error.put_string ("Error reading packet: "+get_error_Message(l_count)+"%N")
--								check false end
--							else

--								if last_buffer_size+l_count>a_max_length then
--									l_count := {AV_EXTERNAL}.avresample_convert(sample_context_ptr, $side_buffer, 0, side_buffer_size, {AV_EXTERNAL}.get_av_frame_struct_extended_data_i(frame,0), 0, {AV_EXTERNAL}.get_av_frame_struct_nb_samples(frame))
--									-- l_error:={AV_EXTERNAL}.audio_resample(sample_context_ptr,side_buffer,{AV_EXTERNAL}.get_av_frame_struct_extended_data_i(frame,0),{AV_EXTERNAL}.get_av_frame_struct_nb_samples(frame))
--									side_buffer_count:=l_count
--									l_ending:=true
--								else
--									l_count := {AV_EXTERNAL}.avresample_convert(sample_context_ptr, $l_temp_buffer, 0, a_max_length - last_buffer_size, {AV_EXTERNAL}.get_av_frame_struct_extended_data_i(frame,0), 0, {AV_EXTERNAL}.get_av_frame_struct_nb_samples(frame))
--									--l_error:={AV_EXTERNAL}.audio_resample(sample_context_ptr,l_temp_buffer,{AV_EXTERNAL}.get_av_frame_struct_extended_data_i(frame,0),{AV_EXTERNAL}.get_av_frame_struct_nb_samples(frame))
--									l_temp_buffer:=l_temp_buffer.plus (l_count)
--									last_buffer_size:=last_buffer_size+l_count
--								end
--							end
--						else
--							l_count:={AV_EXTERNAL}.av_samples_get_buffer_size(create {POINTER},channel_count_internal,
--								{AV_EXTERNAL}.get_av_frame_struct_nb_samples(frame),fmt,1)
--							if l_count<0 then
--								io.error.put_string ("Error reading packet: "+get_error_Message(l_count)+"%N")
--								check false end
--							else

--								if last_buffer_size+l_count>a_max_length then
--									side_buffer.memory_copy ({AV_EXTERNAL}.get_av_frame_struct_extended_data_i(frame,0), l_count)
--									side_buffer_count:=l_count
--									l_ending:=true
--								else
--									l_temp_buffer.memory_copy ({AV_EXTERNAL}.get_av_frame_struct_extended_data_i(frame,0), l_count)
--									l_temp_buffer:=l_temp_buffer.plus (l_count)
--									last_buffer_size:=last_buffer_size+l_count
--								end
--							end
--						end
--					end
--				end
--				{AV_EXTERNAL}.av_frame_unref(frame)
--			end
--			if is_thread_safe then
--				media_mutex.unlock
--			end
--		end



	byte_per_buffer_sample:INTEGER
		once
			Result:=1
		end

feature --Access


	channel_count:INTEGER
			-- Get the channel number of the sound (1=mono, 2=stereo, etc.).
		do
			Result:=channel_count_internal
		end

	frequency:INTEGER
			-- Get the frequency (sample rate) of the sound.
		do
			Result:=frequency_internal
		end

	bits_per_sample:INTEGER
			-- Get the bit resolution of one frame of the sound.
		do
			Result:=bits_per_sample_internal
		end

	is_signed:BOOLEAN
			-- Return true if the frames in the buffer are signed.
		do
			Result:=is_signed_internal
		end

	is_seekable:BOOLEAN
			-- Return true if the sound support the seek functionnality.
		once("PROCESS")
			Result:=true
		end



feature {NONE} -- Implementation - Methodes


	dispose
		do
			if is_resampling then
				if not side_buffer_internal.is_default_pointer then
					{AV_EXTERNAL}.av_freep($side_buffer_internal)
				end
				{AV_EXTERNAL}.avresample_free($sample_context_ptr)
			end
			close_codec(codec_context_ptr)
			{AV_EXTERNAL}.av_freep(frame)
			precursor
		end

feature {NONE} -- Implementation - Variables

	stream_index:INTEGER
	codec_context_ptr:POINTER

	frame:POINTER
	got_frame:BOOLEAN

	frequency_internal:INTEGER
	channel_count_internal:INTEGER
	is_signed_internal:BOOLEAN
	bits_per_sample_internal:INTEGER
	fmt:NATURAL

	side_buffer:POINTER
	side_buffer_internal:POINTER
	side_buffer_linesize:INTEGER
	side_buffer_size:INTEGER
	side_buffer_count:INTEGER

	is_resampling:BOOLEAN
	sample_context_ptr:POINTER


end
