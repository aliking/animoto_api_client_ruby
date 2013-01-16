module Animoto
  module Styles

    ANIMOTO_ORIGINAL      = "original"
    WATERCOLOR_SEASHORE   = "mothers_day_2011"
    DUSK_RETREAT          = "elegance_12"
    VINTAGE_VOYAGE        = "vintage"
    COSMIC_TIDINGS        = "cosmic_tidings"
    WONDERLAND_OF_SNOW    = "wonderland_of_snow"
    THROUGH_THE_BLOSSOMS  = "valentines_day_2012_hands"
	WATER				  = "elements_water"
	SIMPLICITY			  = "slideshow_1"
	AIR				      = "elements_air"
	FIRE				  = "elements_fire"
	EARTH				  = "elements_earth"
	COLOR_FOLD			  = "Cubist_style"
	COMING_UP_ROSES		  = "valentines_2011"
	WRAPPING_SCRAPS		  = "xmas-2010-style1"
	THE_WINDING_VINE	  = "mothers_day"
	POPUP_PANDEMONIUM	  = "holiday_popup_pandemonium"
	STARRY_NIGHT		  = "holiday_starry_night"
	RETRO_WHEEL			  = "viewmaster"
	
    DEPRECATED_NAMES = {
      :ORIGINAL         => :ANIMOTO_ORIGINAL,
      :MOTHERS_DAY_2011 => :WATERCOLOR_SEASHORE,
      :ELEGANCE         => :DUSK_RETREAT,
      :VINTAGE          => :VINTAGE_VOYAGE
    }

    def self.const_missing old_name
      if new_name = DEPRECATED_NAMES[old_name]
        warn("The style name \"#{old_name.to_s}\" is deprecated. Use \"#{new_name}\" instead.")
        const_set(old_name, const_get(new_name))
      else
        super
      end
    end
  end
end
