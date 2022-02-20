cat index.html > standalone.html; # cut standalone.html
echo "<script>" >> standalone.html; # append
cat xhr.bc.js >> standalone.html; # append
echo "</script>" >> standalone.html # append
