# Reads from $(INPUT), prints result out
include common.mk

# Convert input to list of digits
DIGITS:=$(call digits,$(INPUT))

# Copy first number to back to make it circular
DIGITS+=$(call car,$(DIGITS))

# List of all the numbers that are followed by the same one
LIST_NEXT=$(strip $(call LIST_NEXT_REC,$1,))
LIST_NEXT_REC=$(if $(call eq,1,$(words $1)),$2,$(call LIST_NEXT_REC,$(call cdr,$1),$2 $(if $(call eq,$(call car,$1),$(call cadr,$1)),$(call car,$1))))



DUPLICATES:=$(call LIST_NEXT,$(DIGITS))
$(info DUPS=$(DUPLICATES))
