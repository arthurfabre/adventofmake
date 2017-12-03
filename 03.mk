include common.mk

# Go through odd numbers until square is greater than input
# 	We know what ring it's on
# 1: Position to find
# 2: Grid to start search at. 1 for init.
RING_NUM=$(if $(call gte,$(call square,$2),$1),$2,$(call RING_NUM,$1,$(call sum,2 $2)))

# First number in ring n is last of n-1 +1
RING_START=$(call sum,1 $(call square,$(call sub,$1 2)))

# New start number of ring for distance calculations
# 1: Ring num
NEW_START=$(call sum,1 $(call div,$1 2))

# Offset between old and new start
DIS_OFFSET=$(call sub,$(call RING_START,$1) $(call NEW_START,$1))

# Distance between number and middle of line (not necessairly closest middle)
# 1: Ring num
# 2: Input number
LINE_DIS=$(call mod,$(call sub,$2 $(call DIS_OFFSET,$1)) $(call sub,$1 1))

%:
	$(eval RING:=$(call RING_NUM,$@,1))
	$(eval RING_POS:=$(call div,$(RING) 2))

	$(eval DISTANCE:=$(call LINE_DIS,$(RING),$@))
	

	$(info res $(call sum,$(RING_POS) $(if $(call gt,$(DISTANCE),$(RING_POS)),$(call sub,$(RING) 1 $(DISTANCE)),$(DISTANCE))))
