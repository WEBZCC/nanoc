# frozen_string_literal: true

module Nanoc
  module Int
    # Module that contains all Nanoc-specific errors.
    #
    # @api private
    module Errors
      Generic = ::Nanoc::Error

      UnmetDependency = ::Nanoc::Core::Errors::UnmetDependency
      NoSuchSnapshot = ::Nanoc::Core::Errors::NoSuchSnapshot
      CannotGetCompiledContentOfBinaryItem = ::Nanoc::Core::Errors::CannotGetCompiledContentOfBinaryItem
      CannotGetParentOrChildrenOfNonLegacyItem = ::Nanoc::Core::Errors::CannotGetParentOrChildrenOfNonLegacyItem
      InternalInconsistency = ::Nanoc::Core::Errors::InternalInconsistency

      # Generic trivial error. Superclass for all Nanoc-specific errors that are
      # considered "trivial", i.e. errors that do not require a full crash report.
      class GenericTrivial < Generic
      end

      # Error that is raised when compilation of an item rep fails. The
      # underlying error is available by calling `#unwrap`.
      class CompilationError < Generic
        attr_reader :item_rep

        def initialize(wrapped, item_rep)
          @wrapped = wrapped
          @item_rep = item_rep
        end

        def unwrap
          @wrapped
        end
      end

      # Error that is raised when a site is loaded that uses a data source with
      # an unknown identifier.
      class UnknownDataSource < Generic
        # @param [String] data_source_name The data source name for which no
        #   data source could be found
        def initialize(data_source_name)
          super("The data source specified in the site’s configuration file, “#{data_source_name}”, does not exist.")
        end
      end

      # Error that is raised during site compilation when an item uses a layout
      # that is not present in the site.
      class UnknownLayout < Generic
        # @param [String] layout_identifier The layout identifier for which no
        #   layout could be found
        def initialize(layout_identifier)
          super("The site does not have a layout with identifier “#{layout_identifier}”.")
        end
      end

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

      # Error that is raised during site compilation when an item (directly or
      # indirectly) includes its own item content, leading to endless recursion.
      class DependencyCycle < Generic
        def initialize(stack)
          start_idx = stack.index(stack.last)
          cycle = stack[start_idx..-2]

          msg_bits = []
          msg_bits << 'The site cannot be compiled because there is a dependency cycle:'
          msg_bits << ''
          cycle.each.with_index do |r, i|
            msg_bits << "    (#{i + 1}) item #{r.item.identifier}, rep #{r.name.inspect}, uses compiled content of"
          end
          msg_bits << msg_bits.pop + ' (1)'

          super(msg_bits.map { |x| x + "\n" }.join(''))
        end
      end

      # Error that is raised when no rules file can be found in the current
      # working directory.
      class NoRulesFileFound < Generic
        def initialize
          super('This site does not have a rules file, which is required for Nanoc sites.')
        end
      end

      # Error that is raised when no compilation rule that can be applied to the
      # current item can be found.
      class NoMatchingCompilationRuleFound < Generic
        # @param [Nanoc::Core::Item] item The item for which no compilation rule
        #   could be found
        def initialize(item)
          super("No compilation rules were found for the “#{item.identifier}” item.")
        end
      end

      # Error that is raised when no routing rule that can be applied to the
      # current item can be found.
      class NoMatchingRoutingRuleFound < Generic
        # @param [Nanoc::Core::ItemRep] rep The item repiresentation for which no
        #   routing rule could be found
        def initialize(rep)
          super("No routing rules were found for the “#{rep.item.identifier}” item (rep “#{rep.name}”).")
        end
      end

      # Error that is raised when a binary item is attempted to be laid out.
      class CannotLayoutBinaryItem < Generic
        # @param [Nanoc::Core::ItemRep] rep The item representation that was attempted
        #   to be laid out
        def initialize(rep)
          super("The “#{rep.item.identifier}” item (rep “#{rep.name}”) cannot be laid out because it is a binary item. If you are getting this error for an item that should be textual instead of binary, make sure that its extension is included in the text_extensions array in the site configuration.")
        end
      end

      # Error that is raised when a textual filter is attempted to be applied to
      # a binary item representation.
      class CannotUseTextualFilter < Generic
        # @param [Nanoc::Core::ItemRep] rep The item representation that was
        #   attempted to be filtered
        #
        # @param [Class] filter_class The filter class that was used
        def initialize(rep, filter_class)
          super("The “#{filter_class.inspect}” filter cannot be used to filter the “#{rep.item.identifier}” item (rep “#{rep.name}”), because textual filters cannot be used on binary items.")
        end
      end

      # Error that is raised when a binary filter is attempted to be applied to
      # a textual item representation.
      class CannotUseBinaryFilter < Generic
        # @param [Nanoc::Core::ItemRep] rep The item representation that was
        #   attempted to be filtered
        #
        # @param [Class] filter_class The filter class that was used
        def initialize(rep, filter_class)
          super("The “#{filter_class.inspect}” filter cannot be used to filter the “#{rep.item.identifier}” item (rep “#{rep.name}”), because binary filters cannot be used on textual items. If you are getting this error for an item that should be textual instead of binary, make sure that its extension is included in the text_extensions array in the site configuration.")
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
