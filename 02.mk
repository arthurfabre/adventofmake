include common.mk

%: %.in
	@echo $(call sum,$(foreach r,$(subst $(newline),$(space),$(subst $(tab),$(pack_sep),$(file <$^))),$(call sub,$(call max,$(call unpack,$r)) $(call min,$(call unpack,$r)))))
