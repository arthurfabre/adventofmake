include common.mk

# List of all the numbers that are followed by the same one
LIST_NEXT=$(strip $(call LIST_NEXT_REC,$1,))
LIST_NEXT_REC=$(if $(call eq,1,$(words $1)),$2,$(call LIST_NEXT_REC,$(call cdr,$1),$2 $(if $(call eq,$(call car,$1),$(call cadr,$1)),$(call car,$1))))

.PHONY:
%:
	@# Convert input to list of digits
	$(eval DIGITS:=$(call digits,$@))

	@# Copy first number to back to make it circular
	$(eval DIGITS+=$(call car,$(DIGITS)))

	$(eval DUPLICATES:=$(call LIST_NEXT,$(DIGITS)))
	$(info DUPS=$(DUPLICATES))
