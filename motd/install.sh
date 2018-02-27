#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=motd

. /srv/http/addonstitle.sh

installstart $@

getuninstall

echo -e "$bar Add new files ..."

file=/etc/motd.logo
echo $file
cat > $file <<'EOF'
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

file=/etc/profile.d/motd.sh
echo $file

if [[ $1 != u ]]; then
	(( $1 == 0 )) && color='\e[38;5;45m' || color='\e[3'${1}m
else
	color=$( redis-cli get motdcolor )
	redis-cli del motdcolor &> /dev/null
fi

echo '#!/bin/bash

echo -e "'$color'$( < /etc/motd.logo )\e[0m\n"
' > $file

echo -e "$bar Modify files ..."

mv -v /etc/motd{,.original} 2> /dev/null

file=/etc/bash.bashrc
echo $file

[[ $( redis-cli get release ) == 0.4b ]] && release='\\[\'$color'\\]04\\[\\e[0m\\]'

sed -i -e '/PS1=/ s/^/#/
' -e '$ a\
PS1=\x27\\[\\e[38;5;242m\\]\\u@\\h'$release':\\[\'$color'\\]\\w \\$\\[\\e[0m\\] \x27
' $file

# \[ \]      - omit charater count when press <home>, <end> key and command history

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
