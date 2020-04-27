# frozen_string_literal: true

module Jekyll
  module Tagories
    module SiteXtension
      def tags
        register_tags_and_categories unless @tags
        @tags
      end

      def categories
        register_tags_and_categories unless @categories
        @categories
      end

      private

      def register_tags_and_categories
        @tags = {}
        @categories = {}

        documents.each do |doc|
          next unless doc.is_a?(Jekyll::Document)

          segregate_doc_by_attr_list(doc, doc.data["tags"], @tags)
          segregate_doc_by_attr_list(doc, doc.data["categories"], @categories)
        end
      end

      def segregate_doc_by_attr_list(doc, list, stash)
        Array(list).each_with_object(stash) do |item, hash|
          hash[item] ||= []
          hash[item] << doc
        end
      end
    end

    Jekyll::Site.prepend(SiteXtension)
    private_constant :SiteXtension
  end
end
