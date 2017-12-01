include common.mk

# List of all the numbers that are followed by the same N apart
LIST_N=$(strip $(call LIST_N_REC,$1,,$(call sum,1 $2)))
# TODO - Base case is too far, can stop when list reaches $(HALF) -1. Need subtraction support.
LIST_N_REC=$(if $(call eq,1,$(words $1)),$2,$(call LIST_N_REC,$(call cdr,$1),$2 $(if $(call eq,$(call car,$1),$(word $3,$1)),$(call car,$1)),$3))

.PHONY:
%:
	@# Convert input to list of digits
	$(eval DIGITS:=$(call digits,$@))

	@# Half the length of the list
	$(eval HALF:=$(call decode,$(call halve_e,$(call encode,$(words $(DIGITS))))))

	@# Copy half the list to make it circular
	$(eval DIGITS+=$(wordlist 1,$(HALF),$(DIGITS)))
	$(info DIGITS=$(DIGITS))

	$(info SUM=$(call sum,$(call LIST_N,$(DIGITS),$(HALF))))
