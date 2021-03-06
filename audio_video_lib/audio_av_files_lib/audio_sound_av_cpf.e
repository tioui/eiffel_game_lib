note
	description: "Summary description for {AUDIO_SOUND_AV_CPF}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUDIO_SOUND_AV_CPF

inherit
	CPF_RESSOURCE

	AUDIO_SOUND_AV_FILE
	rename
		make as make_file,
		make_thread_safe as make_thread_safe_file
	undefine
		restart
	redefine
		fill_buffer,
		dispose
	end

create
	make,
	make_with_read_buffer_size,
	make_thread_safe,
	make_with_read_buffer_size_thread_safe

feature {NONE} -- Initialization

	make_with_read_buffer_size(a_cpf:CPF_PACKAGE_FILE;a_index:INTEGER;a_read_buffer_size:INTEGER)
		require
			a_read_buffer_size>0
			-- Initialization for `Current'.
		do
			init_library
			cpf:=a_cpf
			cpf_index:=a_index

			bio_buffer:={AV_EXTERNAL}.av_malloc(a_read_buffer_size+{AV_EXTERNAL}.FF_INPUT_BUFFER_PADDING_SIZE)
			cpf.mutex_lock
			cpf.select_sub_file (cpf_index)
			avio_context:={AV_EXTERNAL}.avio_alloc_context(bio_buffer,a_read_buffer_size,0,a_cpf.get_current_cpf_infos_ptr,
								{AV_EXTERNAL}.av_more_read_packet,create{POINTER},{AV_EXTERNAL}.av_more_seek)
			check not avio_context.is_default_pointer end
			format_context_pointer:={AV_EXTERNAL}.avformat_alloc_context
			{AV_EXTERNAL}.set_av_format_context_struct_pb(format_context_pointer,avio_context)
			make_file("Stream")
			last_offset:=cpf.current_offset
			cpf.mutex_unlock
		end

	make(a_cpf:CPF_PACKAGE_FILE;a_index:INTEGER)
			-- Initialization for `Current'.
		do
			make_with_read_buffer_size(a_cpf,a_index,4096)
		end

	make_thread_safe(a_cpf:CPF_PACKAGE_FILE;a_index:INTEGER)
		do
			make(a_cpf,a_index)
			is_thread_safe:=true
			create media_mutex.make
		end

	make_with_read_buffer_size_thread_safe(a_cpf:CPF_PACKAGE_FILE;a_index:INTEGER;a_read_buffer_size:INTEGER)
		do
			make_with_read_buffer_size(a_cpf,a_index,a_read_buffer_size)
			is_thread_safe:=true
			create media_mutex.make
		end

feature {GAME_AUDIO_SOURCE}

	fill_buffer(a_buffer:POINTER;a_max_length:INTEGER)
		do
			cpf.mutex_lock
			if cpf.current_file_index/=cpf_index or else not cpf.current_offset_is_in_selected_file then
				cpf.select_sub_file (cpf_index)
			end
			if cpf.current_offset/=last_offset then
				cpf.seek_from_begining (last_offset)
			end
			precursor(a_buffer,a_max_length)
			if cpf.current_offset_is_in_selected_file then
				last_offset:=cpf.current_offset
			else
				last_offset:=0
			end
			cpf.mutex_unlock
		end

feature-- Access

	restart
		do
			cpf.mutex_lock
			cpf.select_sub_file (cpf_index)
			Precursor
			last_offset:=cpf.current_offset
			cpf.mutex_unlock
		end

feature {NONE} -- Implementation - Routines

	dispose
		do
			if is_resampling then
				{AV_EXTERNAL}.audio_resample_close(sample_context_ptr)
			end
			{AV_EXTERNAL}.av_free(side_buffer)
			close_codec(codec_context_ptr)
			{AV_EXTERNAL}.av_free(frame)
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
			{AV_EXTERNAL}.avformat_free_context(format_context_pointer)
			{AV_EXTERNAL}.av_free(avio_context)
--			{AV_EXTERNAL}.av_free(bio_buffer)	-- I don't know why, but avformat_free_context free the bio_buffer.
		end

feature {NONE} -- Implementation - Variables

	cpf:CPF_PACKAGE_FILE
	cpf_index:INTEGER
	last_offset:INTEGER

	avio_context:POINTER
	bio_buffer:POINTER
end
