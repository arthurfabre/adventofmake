# Empty variable
empty:=

# Single comma
comma:=,

# Single space character
space:=$(empty) $(empty)

# Single newline character
define newline


endef

# Single tab character
define tab
	
endef

# List of base 10 digits
digit_list:=0 1 2 3 4 5 6 7 8 9


# STRING

# If $1 is in $2, and $2 is in $1 then $1 == $2
eq=$(and $(findstring $(strip $1),$(strip $2)),$(findstring $(strip $2),$(strip $1)))


# LISTS
# Packed list seperator
pack_sep:=|

# Pack a list into a single string. Useful for nested lists.
pack=$(subst $(space),$(pack_sep),$(strip $1))

# Unpack a string produced by pack()
unpack=$(strip $(subst $(pack_sep),$(space),$1))

# car of a list
car=$(firstword $1)
# car of packed list
p_car=$(call car,$(call unpack,$1))

# cdr of a list
cdr=$(wordlist 2,$(words $1),$1)
# packed cdr of packed list
p_cdr=$(call pack,$(call cdr,$(call unpack,$1)))

# various car/cdr combinations
# TODO - Autogenerate these. caar, cdaar and friends will be useless as we can't nest lists
cadr=$(call car,$(call cdr,$1))
cddr=$(call cdr,$(call cdr,$1))


# NUMBERS
# _e suffix indicates function operates on encoded numbers (except for decode :P)

# Digits of number as list 1212 -> 1 2 1 2
# Strip to remove last trailing space
digits=$(strip $(call _digits_rec,$(digit_list),$1))
# 1: digits left to process
# 2: string to process
_digits_rec=$(if $(strip $1),$(call _digits_rec,$(call cdr,$1),$(subst $(call car,$1),$(call car,$1)$(space),$2)),$2)

# Encoded numbers
zero:=
one:=x
two:=x x

# Sum pair
sum_e=$1 $2

# Sum list of packed, encoded numbers
sum_all_e=$(foreach n,$1,$(call unpack,$n))

# Multiply pair
mul_e=$(foreach d,$1,$2)

# Divise pair
div_e=$(subst M,x,$(filter-out x,$(subst $2,M,$1)))

# Modulus
mod_e=$(filter-out M,$(subst $2,M,$1))

# Subtract pair
sub_e=$(filter-out xx,$(join $1,$2))

# Subtract list of packed, encoded numbers
sub_all_e=$(call _sub_all_e_rec,$(call cdr,$1),$(call unpack,$(call car,$1)))
_sub_all_e_rec=$(if $(strip $1),$(call _sub_all_e_rec,$(call cdr,$1),$(call sub_e,$2,$(call unpack,$(call car,$1)))),$2)

# Halve an encoded number
halve_e=$(call div_e,$1,$(two))

# Raise to the power
# 1: Number
# 2: Power
pow_e=$(foreach d,$(call cdr,$2),$(call mul_e,$1,$1))
square_e=$(call pow_e,$1,$(two))

# 2^16
# Max int we know how to encode
max_int:=$(call square_e,$(call square_e,$(call square_e,$(call square_e,$(two)))))

# Decimal int from encoded
decode=$(words $1)

# Encoded int from decimal
encode=$(wordlist 1,$1,$(max_int))

# Is $1 greater than or equal to $2?
gte=$(if $(call eq,0,$2),$1,$(wordlist $2,$1,$(max_int)))
# Is $1 strictly greater than $2?
gt=$(if $(call eq,$1,$2),,$(call gte,$1,$2))
# Is $1 less than or equal to $2?
lte=$(call gte,$2,$1)
# Is $1 strictly less than $2?
lt=$(call gt,$2,$1)

# Maximum of a list of decimals
max=$(call _max_rec,$1,0)
_max_rec=$(if $(strip $1),$(call _max_rec,$(call cdr,$1),$(if $(call gt,$(call car,$1),$2),$(call car,$1),$2)),$2)

# Minimum of a list of decimals
# TODO - Merge this with max somehow?
min=$(call _min_rec,$1,$(call car,$1))
_min_rec=$(if $(strip $1),$(call _min_rec,$(call cdr,$1),$(if $(call gt,$(call car,$1),$2),$2,$(call car,$1))),$2)

# Sum list of decimals
sum=$(call decode,$(call sum_all_e,$(foreach n,$1,$(call pack,$(call encode,$n)))))

# Subtract list of decimals
# TODO - Make a generic call all with pack + encode + decode function
sub=$(call decode,$(call sub_all_e,$(foreach n,$1,$(call pack,$(call encode,$n)))))

# Divide two decimals (input as list)
div=$(call decode,$(call div_e,$(call encode,$(call car,$1)),$(call encode,$(call cadr,$1))))

# Modulus of two decimals (input as list)
mod=$(call decode,$(call mod_e,$(call encode,$(call car,$1)),$(call encode,$(call cadr,$1))))

# $1 to the power of $2
pow=$(call decode,$(call pow_e,$(call encode,$1),$(call encode,$2)))
square=$(call decode,$(call pow_e,$(call encode,$1),$(two)))
