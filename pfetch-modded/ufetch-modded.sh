#!/usr/bin/env bash


# Get memory info "borrowed" from ufetch
get_memory() {

        while IFS=':k '  read -r key val _; do
            case $key in
                MemTotal)
                    mem_used=$((mem_used + val))
                    mem_full=$val
                ;;

                Shmem)
                    mem_used=$((mem_used + val))
                    ;;

                    MemFree|Buffers|Cached|SReclaimable)
                        mem_used=$((mem_used - val))
                    ;;
                esac
            done < /proc/meminfo

            mem_used=$((mem_used / 1024))
            mem_full=$((mem_full / 1024))

            echo "$mem_used/$mem_full MB"

}

# $user is already defined
host="$(hostname)"
os="$(awk -F= '/PRETTY/ {gsub(/"/,"");print $2}' /etc/os-release)"
kernel="$(uname -sr)"
uptime="$(uptime | awk -F, '{sub(".*up ",x,$1);print $1}' | sed -e 's/^[ \t]*//')"
packages="$(printf '%s\n' /var/lib/eopkg/package/* | wc --lines)"
mem="$(get_memory)"
shell="$(basename "$SHELL")"

# ui detection
if [ -n "${DE}" ]; then
    ui="${DE}"
    uitype='DE'
elif [ -n "${WM}" ]; then
    ui="${WM}"
    uitype='WM'
elif [ -n "${XDG_CURRENT_DESKTOP}" ]; then
    ui="${XDG_CURRENT_DESKTOP}"
    uitype='DE'
elif [ -n "${DESKTOP_SESSION}" ]; then
    ui="${DESKTOP_SESSION}"
    uitype='DE'
elif [ -f "${HOME}/.xinitrc" ]; then
    ui="$(tail -n 1 "${HOME}/.xinitrc" | cut -d ' ' -f 2)"
    uitype='WM'
elif [ -f "${HOME}/.xsession" ]; then
    ui="$(tail -n 1 "${HOME}/.xsession" | cut -d ' ' -f 2)"
    uitype='WM'
else
    ui='unknown'
    uitype='UI'
fi

# define colours
if [ -x "$(command -v tput)" ]; then
    bold="$(tput bold)"
    reset="$(tput sgr0)"
    purple="$(tput setaf 205)"
    white="$(tput setaf 15)"
    grey="$(tput setaf 247)"
    orange="$(tput setaf 214)"
    yellow="$(tput setaf 228)"
    blue="$(tput setaf 81)"
    
fi

# set colour variables
lc="${reset}${bold}"    
ic="${reset}"      
c0="${reset}${purple}"           
c1="${reset}${white}"
c2="${reset}${grey}"
c3="${reset}${blue}" 
c4="${reset}${yellow}" 
c5="${reset}${orange}" 
bc0="${reset}${purple}${bold}"           
bc1="${reset}${white}${bold}"
bc2="${reset}${grey}${bold}"
bc3="${reset}${blue}${bold}" 
bc4="${reset}${yellow}${bold}" 
bc5="${reset}${orange}${bold}" 


# pass argument "beer" to this script for beer, otherwise normal Solus OS ascii
if [ "$1" == "beer" ]; then
cat <<EOF

${c3}                   ${bc4}.sssssssss.${reset}
${c3}             ${bc4}.sssssssssssssssssss${reset}         ${bc3}${USER}${ic}${bc2}@${bc0}${host}${reset}
${c3}           ${bc4}sssssssssssssssssssssssss${reset}      ${lc}OS:        ${ic}${os}${reset}
${c3}          ${bc4}ssssssssssssssssssssssssssss${reset}    ${lc}KERNEL:    ${ic}${kernel}${reset}
${c3}           ${bc4}@@sssssssssssssssssssssss@ss${reset}   ${lc}UPTIME:    ${ic}${uptime}${reset}
${c3}           |${bc4}s@@@@sssssssssssssss@@@@s${c3}|${bc4}s${reset}   ${lc}PACKAGES:  ${ic}${packages}${reset} 
${c3}      _____|${bc4}sssss@@@@@sssss@@@@@sssss${c3}|${bc4}s${reset}   ${lc}MEMORY:    ${ic}${mem}${reset}  
${c3}    /       ${bc4}sssssssss@sssss@sssssssss${c3}|${bc4}s${reset}   ${lc}SHELL:     ${ic}${shell}${reset}
${c3}   /  .----+${c5}.${bc4}ssssssss@sssss@ssssssss${c5}.${c3}|${reset}    ${lc}${uitype}:        ${ic}${ui}${reset}
${c3}  /  /     |${c5}...${bc4}sssssss@sss@sssssss${c5}...${c3}|${reset}
${c3} |  |      |${c5}.......${bc4}sss@sss@ssss${c5}......${c3}|${reset}
${c3} |  |      |${c5}..........${bc4}s@ss@sss${c5}.......${c3}|${reset}
${c3} |  |      |${c5}...........${bc4}@ss@${c5}..........${c3}|${reset}
${c3}  \  \     |${c5}............${bc4}ss@${c5}..........${c3}|${reset}
${c3}   \  '----+${c5}...........${bc4}ss@${c5}...........${c3}|${reset}
${c3}    \______ ${c5}.........................${c3}|${reset}
${c3}           |${c5}.........................${c3}|${reset}
${c3}           |${c5}.........................${c3}|${reset}
${c3}            |${c5}.......................${c3}|${reset}
${c3}               |_________________|${reset}


EOF
else
# if no arguments passed("beer") then just display Solus OS ascii
cat <<EOF
 
${c0}             -----------${reset}                ${bc3}${USER}${ic}${bc2}@${bc0}${host}${reset}
${c0}           --${bc1}x${c0}-------------${reset}             ${lc}OS:        ${ic}${os}${reset}
${c0}        ----${bc1}xxx${c0}---------------${reset}          ${lc}KERNEL:    ${ic}${kernel}${reset}      
${c0}      -----${bc1}xxxxx${c0}----------------${reset}        ${lc}UPTIME:    ${ic}${uptime}${reset}      
${c0}    ------${bc1}xxxxxxx${c0}-----------------${reset}      ${lc}PACKAGES:  ${ic}${packages}${reset}     
${c0}   ------${bc1}xxxxxxxxx${c0}------------------${reset}    ${lc}MEMORY:    ${ic}${mem}${reset}  
${c0}  ------${bc1}xxxxxxxxxxx${c0}--${bc1}x${c0}---------------${reset}   ${lc}SHELL:     ${ic}${shell}${reset}   
${c0} ------${bc1}xxxxxxxxxxxxx${c0}--${bc1}xx${c0}--------------${reset}  ${lc}${uitype}:        ${ic}${ui}${reset}
${c0} -----${bc1}xxxxxxxxxxxxxx${c0}--${bc1}xxxx${c0}---${bc1}xx${c0}-------${reset}
${c0} ----${bc1}xxxxxxxxxxxxxxx${c0}--${bc1}xxxxx${c0}---${bc1}xxx${c0}------${reset}
${c0} ---${bc1}xxxxxxxxxxxxxxxx${c0}--${bc1}xxxxxx${c0}---${bc1}xxxx${c0}----${reset}
${c0} --${bc1}xxxxxxxxxxxxxxxxx${c0}--${bc1}xxxxxxx${c0}--${bc1}xxxxx${c0}---${reset}
${c0} -${bc1}xxxxxxxxxxxxxxxxxx${c0}--${bc1}xxxxxxxx${c0}--${bc1}xxxxx${c0}-${reset}
${bc1} xxxxxxxxxxxxxxxxxxx${c0}--${bc1}xxxxxxxx${c0}--${bc1}xxxxxx${reset}
${c2}  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx${reset}
${c3}    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx${reset}
${c3}     xxxxxxxxxxxxxxxxxxxxxxxxxxxxx${reset}
${c3}       xxxxxxxxxxxxxxxxxxxxxxxxx${reset} 
${c3}           xxxxxxxxxxxxxxxxxx${reset}


EOF
fi
