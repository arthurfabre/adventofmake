include common.mk

%: %.in
	@echo $(call sum,$(foreach p,$(subst $(newline),$(space),$(subst $(space),$(pack_sep),$(file <$^))),$(if $(call eq,$(words $(call unpack,$p)),$(words $(sort $(call unpack,$p)))),1,0)))
