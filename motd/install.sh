#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=motd

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

installstart $@

getuninstall

echo -e "$bar Add new files ..."

file=/etc/motd.logo
echo $file

string=$( cat <<'EOF'
                          .,;uh         
                   .,;cdk0XNWMM,        
             .,cdONMMMMMMMMMMMM:        
         .:kXWMMMWKkdolcclkMMMM:        
        ;WMMMXx?'''        KMMM:        
        :MMN'              xMMM.        
        .WMMc             :0MMM         
         dMMW;      ,     :WMMM         
         .NMMWxdxkK0;     'NMMM.        
          cMMMMWKx;:      'kMMM.        
           :lNNl''   ,     oMMM:        
                  .oK;     xMMM,        
              .unWMNc     .NMMd         
               ':do:'     kMMk'         
                        .kMMx'          
                      .oNMX;'           
               k,   .dWMWo'             
               kMNo0WMXo'               
                dNNOd;'                 
                 ''                     
EOF
)
echo "$string" > $file

file=/etc/profile.d/motd.sh
echo $file

if [[ $1 != u ]]; then
	(( $1 == 0 )) && color='\e[38;5;45m' || color='\e[3'${1}m
else
	color=$( redis-cli get motdcolor )
	redis-cli del motdcolor &> /dev/null
fi

string=$( cat <<EOF
#!/bin/bash

echo -e "'$color'$( < /etc/motd.logo )\e[0m\n"
EOF
)
echo "$string" > $file

echo -e "$bar Modify files ..."

mv -v /etc/motd{,.backup}

file=/etc/bash.bashrc
echo $file

[[ $( redis-cli get release ) == 0.4b ]] && release='\\[\'$color'\\]04\\[\\e[0m\\]'

commentS 'PS1='

string=$( cat <<'EOF'
PS1='\[\e[38;5;242m\]\u@\h\[\e[38;5;45m\]04\[\e[0m\]:\[\e[38;5;45m\]\w \$\[\e[0m\] '
EOF
)
appendS '$'

# \[ \]      - omit 'color syntax' count when press <home>, <end> key and command history
# PS1='\[\e[38;5;'$color'm\]\u@\h:\[\e[0m\]\w \$ '
# \x27       - escaped <'>
# \\         - escaped <\>
# \e[38;5;Nm - color
# \e[0m      - reset color
# \u         - username
# \h         - hostname
# \w         - current directory
# \$         - promt symbol: <$> users; <#> root

installfinish $@

title -nt "$info Relogin to see new $title."
