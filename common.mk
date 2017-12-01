# Empty variable
empty:=

# Single comma
comma:=,

# Single space character
space:=$(empty) $(empty)

# List of base 10 digits
digit_list:=0 1 2 3 4 5 6 7 8 9


# LISTS

# Pack a list into a single string. Useful for passing to functions
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
digits=$(call unpack,$(call _digits_rec,$(call pack,$(digit_list)),$(call pack,$1)))
# 1: digits left to process
# 2: string to process
_digits_rec=$(if $(strip $1),$(call _digits_rec,$(call p_cdr,$1),$(call pack,$(subst $(call p_car,$1),$(call p_car,$1)$(space),$2))),$2)
