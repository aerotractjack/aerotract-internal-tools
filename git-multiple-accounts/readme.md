# Handle multiple GitHub/gh accounts on one machine

# Usage

`$ switchgit.sh -h` to see help menu

### Register your current account
`$ switchgit.sh init_profile`

### Register another account (using GitHub.com)
`$ switchgit.sh init_new_profile`

### (Optionally) Register as many more as you need...
`$ switchgit.sh init_new_profile`

### Swap to another (previously registered) profile
`$ switchgit.sh swap_profile myotherprofile`

### Check which account is logged in
`$ switchgit.sh who`

### Swap back and forth
```
$ switchgit.sh swap_profile workprofile
Swapped profile to workprofile
$ switchgit.sh who
workprofile
$ cd work; ... do some work ...; git push
$ cd ../personal
$ switchgit.sh swap_profile personalprofile
Swapped profile to personalprofile
$ switchgit.sh who
personalprofile
$ ... do some personal work ...; git push
```