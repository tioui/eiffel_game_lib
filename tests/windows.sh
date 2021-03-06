#!/bin/bash

if [ -z "$ISE_EIFFEL" ];
then
	export ISE_EIFFEL=/c/Program Files/Eiffel Software/EiffelStudio 14.05 GPL
fi

if [ -z "$EIFFEL_LIBRARY" ];
then
	export EIFFEL_LIBRARY=$ISE_EIFFEL
fi

export ES_COMPILER="$ISE_EIFFEL/studio/spec/windows/bin/ec.exe"

PARAM=$1

function eifgensLibClear () {
	rm -rf "$EIFFEL_LIBRARY/contrib/library/game/audio_lib/EIFGENs"
	rm -rf "$EIFFEL_LIBRARY/contrib/library/game/audio_snd_files_lib/EIFGENs"
	rm -rf "$EIFFEL_LIBRARY/contrib/library/game/audio_video_lib/EIFGENs"
	rm -rf "$EIFFEL_LIBRARY/contrib/library/game/cpf_lib/EIFGENs"
	rm -rf "$EIFFEL_LIBRARY/contrib/library/game/custom_package_file_app/EIFGENs"
	rm -rf "$EIFFEL_LIBRARY/contrib/library/game/game_core_lib/EIFGENs"
	rm -rf "$EIFFEL_LIBRARY/contrib/library/game/game_effects_lib/EIFGENs"
	rm -rf "$EIFFEL_LIBRARY/contrib/library/game/game_images_files_lib/EIFGENs"
	rm -rf "$EIFFEL_LIBRARY/contrib/library/game/game_text_lib/EIFGENs"
}

function eifgensExClear () {
	rm -rf "$EIFFEL_LIBRARY/contrib/library/game/exemples/anim1/EIFGENs"
	rm -rf "$EIFFEL_LIBRARY/contrib/library/game/exemples/anim2/EIFGENs"
	rm -rf "$EIFFEL_LIBRARY/contrib/library/game/exemples/audio-console1/EIFGENs"
	rm -rf "$EIFFEL_LIBRARY/contrib/library/game/exemples/audio-console2/EIFGENs"
	rm -rf "$EIFFEL_LIBRARY/contrib/library/game/exemples/audio_video/EIFGENs"
	rm -rf "$EIFFEL_LIBRARY/contrib/library/game/exemples/audio_wav/EIFGENs"
	rm -rf "$EIFFEL_LIBRARY/contrib/library/game/exemples/background_move/EIFGENs"
	rm -rf "$EIFFEL_LIBRARY/contrib/library/game/exemples/cpf/project/EIFGENs"
	rm -rf "$EIFFEL_LIBRARY/contrib/library/game/exemples/doppler/EIFGENs"
	rm -rf "$EIFFEL_LIBRARY/contrib/library/game/exemples/effects/EIFGENs"
	rm -rf "$EIFFEL_LIBRARY/contrib/library/game/exemples/mouse-text/EIFGENs"
	rm -rf "$EIFFEL_LIBRARY/contrib/library/game/exemples/keyboard-text/EIFGENs"
	rm -rf "$EIFFEL_LIBRARY/contrib/library/game/exemples/sound/EIFGENs"
	rm -rf "$EIFFEL_LIBRARY/contrib/library/game/exemples/surface1/EIFGENs"
	rm -rf "$EIFFEL_LIBRARY/contrib/library/game/exemples/surface2/EIFGENs"
	rm -rf "$EIFFEL_LIBRARY/contrib/library/game/exemples/video/EIFGENs"
	rm -rf "$EIFFEL_LIBRARY/contrib/library/game/exemples/video_cpf/project/EIFGENs"
	rm -rf "$EIFFEL_LIBRARY/contrib/library/game/exemples/audio_video_cpf/project/EIFGENs"
}

function compileSubLib () {
	echo "*************************************************************************"	
	echo "Testing" $1 "..."
	cd "$EIFFEL_LIBRARY/contrib/library/game/$2"
	"$ES_COMPILER" -batch -config $3 -target $4
	if (( $? )) 
	then 
		echo Error while compiling eiffel code of $1.
		exit 1
	fi
	echo "done."
}

function compileEx () {
	echo "*************************************************************************"	
	echo "Testing" $1 "..."
	cd "$EIFFEL_LIBRARY/contrib/library/game/exemples/$2"
	"$ES_COMPILER" -batch -c_compile -config $3 -target $4
	if (( $? )) 
	then 
		echo Error while compiling eiffel code of $1.
		exit 1
	fi
	if [ ! -f "$EIFFEL_LIBRARY/contrib/library/game/exemples/$2/EIFGENs/$4/W_code/$5.exe" ];
  	then
    		echo Error while compiling c code of $1.
   		exit 1
  	fi
	echo "done."
}

eifgensExClear
eifgensLibClear

if [[ "1$PARAM" != "1clean" ]]
then
	compileSubLib "Custom Package Files Lib" "cpf_lib" "cpf_lib.ecf" "cpf_lib"
	compileSubLib "Game Core Lib" "game_core_lib" "game_core_lib.ecf" "game_core_lib" 
	compileSubLib "Game Effects Lib" "game_effects_lib" "game_effects_lib.ecf" "game_effects_lib"
	compileSubLib "Game Images Files Lib" "game_images_files_lib" "game_images_files_lib.ecf" "game_images_files_lib"
	compileSubLib "Game Text Lib" "game_text_lib" "eiffel_text_lib.ecf" "game_text_lib"
	compileSubLib "Audio Lib" "audio_lib" "audio_lib.ecf" "audio_lib"
	compileSubLib "Audio AV Files Lib" "audio_video_lib" "audio_av_files_lib.ecf" "audio_av_files_lib"
	compileSubLib "Video AV Files Lib" "audio_video_lib" "video_av_files_lib.ecf" "video_av_files_lib"
	compileSubLib "Audio/Video AV Files Lib" "audio_video_lib" "audio_video_av_files_lib.ecf" "audio_video_av_files_lib"
	compileSubLib "Audio Snd Files Lib" "audio_snd_files_lib" "audio_snd_files_lib.ecf" "audio_snd_files_lib"


	compileEx "Animation Exemple 1" "anim1" "anim1.ecf" "anim1" "anim1"
	compileEx "Animation Exemple 2" "anim2" "anim2.ecf" "anim2" "anim2"
	compileEx "Audio Console Exemple 1" "audio-console1" "audio-console1.ecf" "audio-console1" "audio-console1"
	compileEx "Audio Console Exemple 2" "audio-console2" "audio-console2.ecf" "audio-console2" "audio-console2"
	compileEx "Audio Video Exemple" "audio_video" "audio_video.ecf" "audio_video" "audio_video"
	compileEx "Audio Video CPF Exemple" "audio_video_cpf/project" "audio_video_cpf.ecf" "audio_video_cpf" "audio_video_cpf"
	compileEx "Audio WAV Exemple" "audio_wav" "audio_wav.ecf" "audio_wav" "audio_wav"
	compileEx "Background Move" "background_move" "background_move.ecf" "background_move" "background_move"
	compileEx "Custom Package Files Exemple" "cpf/project" "cpf.ecf" "cpf" "cpf"
	compileEx "Doppler Effect" "doppler" "doppler.ecf" "doppler" "doppler"
	compileEx "Visual Effects Exemple" "effects" "effects.ecf" "effects" "effects"
	compileEx "Mouse and Text Exemple" "mouse-text" "mouse-text.ecf" "mouse-text" "mouse-text"
	compileEx "Keyboard and Text Exemple" "keyboard-text" "keyboard-text.ecf" "keyboard-text" "keyboard-text"
	compileEx "Sound Exemple" "sound" "sound.ecf" "sound" "sound"
	compileEx "Surface Exemple 1" "surface1" "surface1.ecf" "surface1"  "surface1"
	compileEx "Surface Exemple 2" "surface2" "surface2.ecf" "surface2" "surface2"
	compileEx "Playing Video Exemple" "video" "video.ecf" "video" "video"
	compileEx "Playing Video CPF Exemple" "video_cpf/project" "video_cpf.ecf" "video_cpf" "video_cpf"

	if [[ "1$PARAM" != "1keep" ]]
	then
		eifgensExClear
		eifgensLibClear
	fi

fi


