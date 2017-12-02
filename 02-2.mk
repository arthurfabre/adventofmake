include common.mk

# 1: Row
# Filter out ensures we don't consider case where a and b are same index
ROW_CALC=$(foreach a,$1,$(foreach b,$(filter-out $a,$1),$(if $(call eq,0,$(call mod,$a $b)),$(call div,$a $b))))

%: %.in
	@echo $(call sum,$(foreach r,$(subst $(newline),$(space),$(subst $(tab),$(pack_sep),$(file <$^))),$(call ROW_CALC,$(call unpack,$r))))
