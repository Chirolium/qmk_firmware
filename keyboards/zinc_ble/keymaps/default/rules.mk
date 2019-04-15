
# Build Options
#   change to "no" to disable the options, or define them in the Makefile in
#   the appropriate keymap folder that will get included automatically
#

define ZINC_CUSTOMISE_MSG
  $(info Zinc customize)
  $(info -  LED_BACK_ENABLE=$(LED_BACK_ENABLE))
  $(info -  LED_UNDERGLOW_ENABLE=$(LED_UNDERGLOW_ENABLE))
  $(info -  LED_ANIMATION=$(LED_ANIMATIONS))
  $(info -  IOS_DEVICE_ENABLE=$(IOS_DEVICE_ENABLE))
endef

# Zinc keyboard customize
LED_BACK_ENABLE = no        # LED backlight (Enable SK6812mini backlight)
LED_UNDERGLOW_ENABLE = no   # LED underglow (Enable WS2812 RGB underlight)
LED_ANIMATIONS = no        # LED animations
IOS_DEVICE_ENABLE = no      # connect to IOS device (iPad,iPhone)
Link_Time_Optimization = no # if firmware size over limit, try this option

####  LED_BACK_ENABLE and LED_UNDERGLOW_ENABLE.
####    Do not enable these with audio at the same time.

### Zinc keyboard 'default' keymap: convenient command line option
##    make ZINC=<options> zinc:defualt
##    option= back | under | na | ios
##    ex.
##      make ZINC=under    zinc:defualt
##      make ZINC=under,ios zinc:defualt
##      make ZINC=back     zinc:default
##      make ZINC=back,na  zinc:default
##      make ZINC=back,ios zinc:default

ifneq ($(strip $(ZINC)),)
  ifeq ($(findstring back,$(ZINC)), back)
    LED_BACK_ENABLE = yes
  else ifeq ($(findstring under,$(ZINC)), under)
    LED_UNDERGLOW_ENABLE = yes
  endif
  ifeq ($(findstring na,$(ZINC)), na)
    LED_ANIMATIONS = no
  endif
  ifeq ($(findstring ios,$(ZINC)), ios)
    IOS_DEVICE_ENABLE = yes
  endif
  $(eval $(call ZINC_CUSTOMISE_MSG))
  $(info )
endif

ifeq ($(strip $(LED_BACK_ENABLE)), yes)
  RGBLIGHT_ENABLE = yes
  OPT_DEFS += -DRGBLED_BACK
  ifeq ($(strip $(LED_UNDERGLOW_ENABLE)), yes)
    $(eval $(call ZINC_CUSTOMISE_MSG))
    $(error LED_BACK_ENABLE and LED_UNDERGLOW_ENABLE both 'yes')
  endif
else ifeq ($(strip $(LED_UNDERGLOW_ENABLE)), yes)
  RGBLIGHT_ENABLE = yes
else
  RGBLIGHT_ENABLE = no
endif

ifeq ($(strip $(IOS_DEVICE_ENABLE)), yes)
    OPT_DEFS += -DIOS_DEVICE_ENABLE
endif

ifeq ($(strip $(LED_ANIMATIONS)), yes)
#    OPT_DEFS += -DRGBLIGHT_ANIMATIONS
     OPT_DEFS += -DLED_ANIMATIONS

endif

ifeq ($(strip $(Link_Time_Optimization)),yes)
    EXTRAFLAGS += -flto -DUSE_Link_Time_Optimization
endif

# Do not enable SLEEP_LED_ENABLE. it uses the same timer as BACKLIGHT_ENABLE
SLEEP_LED_ENABLE = no    # Breathing sleep LED during USB suspend


# Uncomment these for debugging
# $(info -- RGBLIGHT_ENABLE=$(RGBLIGHT_ENABLE))
# $(info -- OPT_DEFS=$(OPT_DEFS))
# $(info )

