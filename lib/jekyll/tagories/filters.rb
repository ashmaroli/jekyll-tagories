# frozen_string_literal: true

module Jekyll
  module Tagories
    module LiquidFilters
      def tagged(input, tag = nil)
        return input unless input.is_a?(Array)

        input.select do |item|
          next false unless item.respond_to?(:data)
          next false if item.data["tags"].empty?
          next true if tag.nil?

          item.data["tags"].include?(tag)
        end
      end

      def categorized(input, category = nil)
        return input unless input.is_a?(Array)

        input.select do |item|
          next false unless item.respond_to?(:data)
          next false if item.data["categories"].empty?
          next true if category.nil?

          item.data["categories"].include?(category)
        end
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::Tagories::LiquidFilters)
