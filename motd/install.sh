#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=motd

. /srv/http/addonstitle.sh

installstart $@

getuninstall

echo -e "$bar Add new files ..."

file=/etc/motd.logo
echo $file
echo "
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
 " > $file

file=/etc/profile.d/motd.sh
echo $file

(( $# == 0 )) && colorlogo='\e[38;5;45m' || colorlogo='\e[3'${1}m

echo '#!/bin/bash

echo -e "'$colorlogo'$( < /etc/motd.logo )\e[0m\n"
' > $file

echo -e "$bar Modify files ..."

mv -v /etc/motd{,.original} 2> /dev/null

file=/etc/bash.bashrc
echo $file
sed -i -e '/PS1=/ s/^/#/
' -e '$ a\
color=242\
colordir='$colorlogo'\
PS1=\x27\\[\\e[38;5;\x27$color\x27m\\]\\u@\\h:\\[\\e[38;5;\x27$colordir\x27m\\]\\w \\$\\[\\e[0m\\] \x27
' $file

# PS1='\[\e[38;5;'$color'm\]\u@\h:\[\e[0m\]\w \$ '
# \x27       - escaped <'>
# \\         - escaped <\>
# \[ \]      - omit charater count when press <home>, <end> key
# \e[38;5;Nm - color
# \e[0m      - reset color
# \u         - username
# \h         - hostname
# \w         - current directory
# \$         - promt symbol: <$> users; <#> root

installfinish $@

title -nt "$info Relogin to see new $title."
