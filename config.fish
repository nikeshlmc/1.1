#source /usr/share/cachyos-fish-config/cachyos-config.fish
set fish_greeting ""
#glances, btop, cava, htop, fastfetch, cmatrix, pipes.sh, :)
#
#Gammastep
alias g27k='gammastep -O 2700 & disown'
alias g3k='gammastep -O 3000 & disown'
alias g35k='gammastep -O 3500 & disown'
alias g4k='gammastep -O 4000 & disown'
alias g45k='gammastep -O 4500 & disown'
alias g5k='gammastep -O 5000 & disown'
alias pgs='pkill gammastep'
alias ck='tty-clock -c -s -C 7 -t'

#Shortcuts
alias c='clear'
alias nau='nautilus & disown'
alias w='waybar & disown'
alias kw='pkill -9 waybar'
alias k='pkill -9 -u nikesh'
alias re='OCL_ICD_VENDORS=/etc/OpenCL/vendors/intel.icd davinci-resolve & disown'
alias bo='flatpak run com.usebottles.bottles & disown'
# alias dlp='yt-dlp -f "bv*[height<=2160]+ba/b[height<=2160]" --merge-output-format mp4'
alias msc='yt-dlp -f "ba" -x --no-playlist --add-metadata'
alias dlp="yt-dlp -f 'bestvideo[height>=2160]+bestaudio/bestvideo+bestaudio/best' --merge-output-format mkv --extractor-args 'youtube:player_client=web_embedded,web_creator,mweb' --js-runtimes deno"
alias bo='flatpak run com.usebottles.bottles & disown'


function enc
    set input $argv[1]
    set out_dir $argv[2]

    function _convert --argument-names f dir
        set name (string replace -r '\.[^.]+$' '' (basename $f))
        if test -n "$dir"
            mkdir -p $dir
            set out "$dir/$name.mov"
        else
            set out (dirname $f)"/$name.mov"
        end

        ffmpeg -i $f -c:v dnxhd -profile:v dnxhr_hq -pix_fmt yuv422p -c:a pcm_s16le $out
    end

    if test -d $input
        for f in $input/*.{mp4,mov,mkv,avi}
            test -e "$f"; or continue
            _convert $f "$out_dir"
        end
    else if test -f $input
        _convert $input "$out_dir"
    end
end


function dec
    if test (count $argv) -lt 1
        echo "Usage: dec <input_file> [output_file.mp4]"
        return 1
    end

    set input $argv[1]
    
    # Determine output path cleanly
    if test (count $argv) -ge 2
        set out $argv[2]
    else
        set name (string replace -r '\.[^.]+$' '' (basename $input))
        set out (dirname $input)"/$name.mp4"
    end

    # Skip if output exists
    if test -f $out
        echo "Skipping $input, output already exists: $out"
        return 0
    end

    # Encoding: High quality, faster processing, and ultra-smooth playback
    ffmpeg -i $input \
        -c:v libx264 \
        -crf 18 \
        -preset faster \
        -tune film \
        -pix_fmt yuv420p \
        -c:a aac -b:a 192k \
        -movflags +faststart \
        $out
end

#Run Gems directly
set -gx PATH $HOME/.local/bin $PATH

#Convert mp3
function m3
    ffmpeg -i $argv[1] -c:a pcm_s24le (string replace -r '\.[^.]+$' '.wav' $argv[1])
end
    
alias gnu='GTK_THEME=Adwaita gnusim8085 & disown'

function ver
    if test (count $argv) -lt 1
        echo "Usage: s <input_file>"
        return 1
    end

    set input $argv[1]
    
    # Strip extension and prepend 's' to the filename
    set dir (dirname $input)
    set name (basename $input)
    set out "$dir/s$name"

    # If input is a .mov, output will be s<name>.mov
    ffmpeg -i $input -vf "crop=ih*(9/16):ih,scale=1080:1920" -c:v libx264 -crf 18 -preset faster -c:a aac -movflags +faststart $out
end

function age
    set birth_epoch (stat -c %W /)
    
    # Fallback to pacman log if filesystem birth date isn't recorded
    if test "$birth_epoch" = "0" -o -z "$birth_epoch"
        set log_date (head -n 1 /var/log/pacman.log | string match -r '^\[(.*?)\]' | string trim -c '[]')
        set birth_epoch (date -d "$log_date" +%s)
    end

    set now_epoch (date +%s)
    set days (math "floor(($now_epoch - $birth_epoch) / 86400)")
    set birth_date (date -d "@$birth_epoch" "+%B %d, %Y (%I:%M %p)")

    echo "Installed : $birth_date"
    echo "Days Active  : $days days"
end

alias fg="WINEDLLOVERRIDES=\"xtool,unarc=n,b\" WINE_LARGE_ADDRESS_AWARE=0 wine setup.exe"
alias iv="cd ~/.wine/drive_c/AC4/ && wine AC4BFSP.exe"

alias v="cd ~/.wine/drive_c/GTAV/ && wine PlayGTAV.bat"
