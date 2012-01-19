module Animoto
  class Postroll
    # Constructs a new postroll. If given a Postroll object, returns
    # it. Otherwise, passes the arguments to the constructor for this
    # Postroll class.
    #
    # @param [Array<Object>] args Postroll objects or constructor params
    # @return [Animoto::Postroll]
    def self.new *args
      args.first.is_a?(self) ? args.first : super
    end

    # The template name for this postroll.
    # @return [String]
    attr_reader :template

    # Creates a new Postroll with the given template name.
    #
    # @param [String] template the template name
    # @return [Animoto::Postroll]
    def initialize template
      @template = template
    end

    # Returns a representation of this postroll as a hash.
    # @return [Hash{String=>Object}]
    def to_hash
      {'template' => @template}
    end

    POWERED_BY_ANIMOTO = new("powered_by_animoto").freeze
    WHITE_LABEL        = new("white_label").freeze
  end
end
