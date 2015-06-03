# Generic test functions for go-ipfs

# Echo the args, run the cmd, and then also fail,
# making sure a test case fails.
test_fsh() {
    echo "> $@"
    eval "$@"
    echo ""
    false
}

# Same as sharness' test_cmp but using test_fsh (to see the output).
# We have to do it twice, so the first diff output doesn't show unless it's
# broken.
test_cmp() {
	diff -q "$@" >/dev/null || test_fsh diff -u "$@"
}

# Same as test_cmp above, but we sort files before comparing them.
test_sort_cmp() {
	sort "$1" >"$1_sorted" &&
	sort "$2" >"$2_sorted" &&
	test_cmp "$1_sorted" "$2_sorted"
}

# Depending on GNU seq availability is not nice.
# Git also has test_seq but it uses Perl.
test_seq() {
	test "$1" -le "$2" || return
	i="$1"
	j="$2"
	while test "$i" -le "$j"
	do
		echo "$i"
		i=$(expr "$i" + 1)
	done
}
