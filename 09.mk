include common.mk

# Remove escaped characters from a string
# Expects ! to not be seperate list elements ie (a b !!!!c !!d c e)
ESC=$(filter-out !%,$(subst !!,,$1))

# Strip any garbage from a string
# foreach is used as let
GRB=$(foreach s,$(call first_match,<,$1),$(if $(call eq,0,$s),$1,$(foreach e,$(call first_match,>,$(wordlist $s,$(words $1),$1)),$(wordlist 1,$(call sub,$s 1),$1) $(call GRB,$(wordlist $(call sum,$s $e),$(words $1),$1)))))

# Number openning matching brackets
# 1: String
MATCH=$(strip $(call MATCH_,$(subst $(comma),,$1),0))
# 2: Bracket level. Init 0.
MATCH_=$(if $(strip $1),$(if $(call eq,{,$(call car,$1)),$(foreach n,$(call sum,1 $2),$n $(call MATCH_,$(call cdr,$1),$n)),$(call MATCH_,$(call cdr,$1),$(call sub,$2 1))))

%: %.in
	@#Expand everything but exclamation marks for ESC
	$(info $(call sum,$(call MATCH,$(call GRB,$(call ESC,$(call char_sep,$(filter-out !,$(ascii_list)),$(file <$^)))))))
