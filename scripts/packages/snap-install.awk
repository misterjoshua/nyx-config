/classic$/ { print "snap install --channel=" $4, "--classic", $1 }
/-$/ { print "snap install --channel=" $4, $1 }
