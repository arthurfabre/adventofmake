# Empty variable
empty:=

# Single comma
comma:=,

# Single space character
space:=$(empty) $(empty)

# List of base 10 digits
digit_list:=0 1 2 3 4 5 6 7 8 9


# STRING

# If $1 is in $2, and $2 is in $1 then $1 == $2
eq=$(and $(findstring $(strip $1),$(strip $2)),$(findstring $(strip $2),$(strip $1)))


# LISTS

# Pack a list into a single string. Useful for nested lists.
pack=$(subst $(space),|,$(strip $1))

# Unpack a string produced by pack()
unpack=$(strip $(subst |,$(space),$1))

# car of a list
car=$(firstword $1)
# car of packed list
p_car=$(call car,$(call unpack,$1))

# cdr of a list
cdr=$(wordlist 2,$(words $1),$1)
# packed cdr of packed list
p_cdr=$(call pack,$(call cdr,$(call unpack,$1)))


# NUMBERS

# Digits of number as list 1212 -> 1 2 1 2
# Strip to remove last trailing space
digits=$(strip $(call _digits_rec,$(digit_list),$1))
# 1: digits left to process
# 2: string to process
_digits_rec=$(if $(strip $1),$(call _digits_rec,$(call cdr,$1),$(subst $(call car,$1),$(call car,$1)$(space),$2)),$2)
