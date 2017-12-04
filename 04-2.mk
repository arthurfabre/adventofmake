include common.mk

%: %.in
	@echo $(call sum,$(foreach p,$(subst $(newline),$(space),$(subst $(space),$(pack_sep),$(file <$^))),$(if $(call eq,$(words $(call unpack,$p)),$(words $(sort $(foreach w,$(call unpack,$p),$(call subst,$(space),,$(call sort,$(call letters,$w))))))),1,0)))
