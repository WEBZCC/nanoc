# frozen_string_literal: true

module Nanoc
  module Int
    # Module that contains all Nanoc-specific errors.
    #
    # @api private
    module Errors
      Generic = ::Nanoc::Core::Error

      NoSuchSnapshot = ::Nanoc::Core::Errors::NoSuchSnapshot
      CannotGetCompiledContentOfBinaryItem = ::Nanoc::Core::Errors::CannotGetCompiledContentOfBinaryItem
      CannotGetParentOrChildrenOfNonLegacyItem = ::Nanoc::Core::Errors::CannotGetParentOrChildrenOfNonLegacyItem
      CannotLayoutBinaryItem = ::Nanoc::Core::Errors::CannotLayoutBinaryItem
      UnknownLayout = ::Nanoc::Core::Errors::UnknownLayout
      CannotUseBinaryFilter = ::Nanoc::Core::Errors::CannotUseBinaryFilter
      CannotUseTextualFilter = ::Nanoc::Core::Errors::CannotUseTextualFilter

      # Error that is raised during site compilation when a layout is compiled
      # for which the filter cannot be determined. This is similar to the
      # {UnknownFilter} error, but specific for filters for layouts.
      class CannotDetermineFilter < Generic
        # @param [String] layout_identifier The identifier of the layout for
        #   which the filter could not be determined
        def initialize(layout_identifier)
          super("The filter to be used for the “#{layout_identifier}” layout could not be determined. Make sure the layout does have a filter.")
        end
      end

      class AmbiguousMetadataAssociation < Generic
        def initialize(content_filenames, meta_filename)
          super("There are multiple content files (#{content_filenames.sort.join(', ')}) that could match the file containing metadata (#{meta_filename}).")
        end
      end
    end
  end
end
