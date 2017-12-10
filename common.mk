# STRING
# Empty variable
empty:=

# Comma character
comma:=,

# Space character
space:=$(empty) $(empty)

# Single newline character
define newline


endef

# Tab character
define tab
	
endef

# Single quote character
define s_quote
'
endef

# Double quote character
define d_quote
"
endef

# Pound / hash character
pound:=\#

# Dollar character
dollar:=$$

# Backslash character
b_slash:=\$(empty)

# Backtick / grave accent
define b_tick:=
`
endef

# List of base 10 digits
digit_list:=0 1 2 3 4 5 6 7 8 9

# List of lower case letters
lower_list:=a b c d e f g h i j k l m n o p q r s t u v w x y z

# List of upper case letters
upper_list:=A B C D E F G H I J K L M N O P Q R S T U V W X Y Z

# List of lower and upper case alphabetic characters
letter_list:=$(lower_list) $(upper_list)

# List of alpha-numeric characters (A-Z a-z 0-9)
alphanum_list:=$(letter_list) $(digit_list)

# List of printable ASCII characters
ascii_list:=$(space) ! $(d_quote) $(pound) $(dollar) % & $(s_quote) ( ) * + $(comma) - . / $(digit_list) : ; < = > ? @ $(upper_list) [ $(b_slash) ] ^ _ $(b_tick) $(lower_list) { | } ~

# Turn a string into a list of characters
# 1: List of characters to search for
# 2: Input string
char_sep=$(if $(strip $1),$(call char_sep,$(call cdr,$1),$(subst $(call car,$1),$(call car,$1)$(space),$2)),$2)

# Turn string of letters (upper or lower) into list of letters
letters=$(strip $(call char_sep,$(letter_list),$1))

# If $1 is in $2, and $2 is in $1 then $1 == $2
eq=$(and $(findstring $(strip $1),$(strip $2)),$(findstring $(strip $2),$(strip $1)))

# Expand to nothing if $1, else "1"
not=$(if $1,,1)

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

# Set word 1 to value 2 in 3
set=$(strip $(wordlist 1,$(call sub,$1 1),$3) $2 $(wordlist $(call sum,$1 1),$(words $3),$3))

# Remove word 1 in 3
del=$(call set,$1,,$2)

# Check if 1 is a valid index in 2
valid=$(and $(call gt,$1,0),$(call lte,$1,$(words $2)))

# Reverse all the elements of a list
reverse=$(if $1,$(call reverse,$(call cdr,$1))$(call car,$1) )

# Index of first item in $2 eq() to $1
# Expands to 0 if not found
first_match=$(call decode,$(call _first_match_rec,$1,$2,$(one)))
_first_match_rec=$(if $(strip $2),$(if $(call eq,$(call car,$2),$1),$3,$(call _first_match_rec,$1,$(call cdr,$2),$(call sum_e,$3,$(one)))),)


# NUMBERS
# _e suffix indicates function operates on encoded numbers (except for decode :P)

# Digits of number as list 1212 -> 1 2 1 2
# Strip to remove last trailing space
digits=$(strip $(call char_sep,$(digit_list),$1))

# Encoded numbers
zero:=
one:=x
two:=x x
three:=x x x
four:=x x x x
five:=x x x x x
six:=x x x x x x
seven:=x x x x x x x
eight:=x x x x x x x x
nine:=x x x x x x x x x

# Sum pair
sum_e=$1 $2

# Sum list of packed, encoded numbers
sum_all_e=$(foreach n,$1,$(call unpack,$n))

# Multiply pair
mul_e=$(foreach d,$1,$2)

# Multiply list of packed, encoded numbers
mul_all_e=$(if $(call eq,1,$(words $1)),$(call unpack,$1),$(call mul_e,$(call unpack,$(call car,$1)),$(call mul_all_e,$(call cdr,$1))))

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
pow_e=$(if $(strip $2),$(call mul_e,$1,$(call pow_e,$1,$(call cdr,$2))),$(one))
square_e=$(call mul_e,$1,$1)

# List of packed encoded numbers from $1 to $2
seq_e=$(if $(call lte_e,$1,$2),$(call pack,$1) $(call seq_e,$(call sum_e,$(one),$1),$2))

# Max int we know how to encode
# 2^(4*5) = 2^20 = 1 048 576
max_int:=$(call pow_e,$(two),$(call mul_e,$(four),$(five)))

# Decimal int from encoded
decode=$(words $1)

# Encoded int from decimal
encode=$(wordlist 1,$1,$(max_int))

# Is $1 greater than or equal to $2?
gte_e=$(call gte,$(words $1),$(words $2))
gt_e=$(call gt,$(words $1),$(words $2))
lte_e=$(call lte,$(words $1),$(words $2))
lt_e=$(call lt,$(words $1),$(words $2))

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

# Multiply list of decimals
mul=$(call decode,$(call mul_all_e,$(foreach n,$1,$(call pack,$(call encode,$n)))))

# Divide two decimals (input as list)
div=$(call decode,$(call div_e,$(call encode,$(call car,$1)),$(call encode,$(call cadr,$1))))

# Modulus of two decimals (input as list)
mod=$(call decode,$(call mod_e,$(call encode,$(call car,$1)),$(call encode,$(call cadr,$1))))

# $1 to the power of $2
pow=$(call decode,$(call pow_e,$(call encode,$1),$(call encode,$2)))
square=$(call decode,$(call square_e,$(call encode,$1),$(two)))
