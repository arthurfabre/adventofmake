include common.mk

# Remove escaped characters from a string
# Expects ! to not be seperate list elements ie (a b !!!!c !!d c e)
ESC=$(filter-out !%,$(subst !!,,$1))

# Count garbage from a string
# foreach is used as let
GRB=$(foreach s,$(call first_match,<,$1),$(if $(call eq,0,$s),0,$(foreach e,$(call first_match,>,$(wordlist $s,$(words $1),$1)),$(call sub,$e 2) $(call GRB,$(wordlist $(call sum,$s $e),$(words $1),$1)))))

%: %.in
	@#Expand everything but exclamation marks for ESC
	$(info $(call sum,$(call GRB,$(call ESC,$(call char_sep,$(filter-out !,$(ascii_list)),$(file <$^))))))
