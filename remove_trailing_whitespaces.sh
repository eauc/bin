#!/usr/bin/env bash

sed -e 's/\s\+$//' | sed -e '
:a
/^\n*$/ {
	$ d
	N
	ba
}
'
