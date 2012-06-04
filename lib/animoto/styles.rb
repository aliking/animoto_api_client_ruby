module Animoto
  module Styles

    ANIMOTO_ORIGINAL      = "original"
    WATERCOLOR_SEASHORE   = "mothers_day_2011"
    DUSK_RETREAT          = "elegance_12"
    VINTAGE_VOYAGE        = "vintage"
    COSMIC_TIDINGS        = "cosmic_tidings"
    WONDERLAND_OF_SNOW    = "wonderland_of_snow"
    THROUGH_THE_BLOSSOMS  = "valentines_day_2012_hands"

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
