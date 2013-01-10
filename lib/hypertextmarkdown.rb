# encoding: UTF-8
require 'hypertextmarkdown/version'
require 'nokogiri'

module HyperTextMarkDown

  class << self

    def to_markdown(str)
      html = Nokogiri::HTML(str)
      # pre-processing / xpath selection here
      html.children.map{|child| mark_element(child)}.join
    end

    private

    def mark_element(element, opts={})
      #puts "\nmark_element(#{element.inspect},#{opts.inspect})"
      if element.is_a?(Nokogiri::XML::Text)
        return "" if element.text.to_s.strip.empty?
        return element.text
      end

      children = element.children

      case element.name.downcase

      when 'br'
        "  \n"

      when 'hr'
        "\n****\n"

      when 'a'
        "[#{children.map{|child| mark_element(child,opts)}.join}](#{element['href']})"

      when 'img'
        "![#{element['alt']}](#{element['src']})"

      when 'em', 'i'
        "*#{children.map{|child| mark_element(child,opts)}.join}*"

      when 'strong', 'b'
        "**#{children.map{|child| mark_element(child,opts)}.join}**"

      when 'span'
        "#{children.map{|child| mark_element(child,opts)}.join}"

      when 'p'
        "#{opts[:indent]}#{children.map{|child| mark_element(child,opts)}.join}\n\n"

      when 'code'
        "\n\n```\n#{children.map{|child| mark_element(child,opts)}.join}\n```\n"

      when 'pre'
        new_indent = "#{opts[:indent]}    "
        "#{opts[:indent]}#{children.map{|child| mark_element(child,opts.merge(:indent=>new_indent))}.join}\n"

      when 'blockquote'
        new_indent = "#{opts[:indent]}  > "
        "#{children.map{|child| mark_element(child,opts.merge(:indent=>new_indent))}.join}"

      when 'h1'
        "# #{children.map{|child| mark_element(child,opts)}.join}\n"
      when 'h2'
        "## #{children.map{|child| mark_element(child,opts)}.join}\n"
      when 'h3'
        "### #{children.map{|child| mark_element(child,opts)}.join}\n"

      when 'ul'
        spacer = opts[:list_type] ? "" : "\n"
        "#{spacer}#{children.map{|child| mark_element(child,opts.merge(:list_type=>:ul))}.join}"

      when 'ol'
        spacer = opts[:list_type] ? "" : "\n"
        "#{spacer}#{children.map{|child| mark_element(child,opts.merge(:list_type=>:ol))}.join}"

      when 'li'
        li_prefix = (opts[:list_type] == :ol) ? "  - " : "  1. "
        new_indent = "#{opts[:indent]}    "
        "#{opts[:indent]}#{li_prefix}#{children.map{|child| mark_element(child,opts.merge(:indent=>new_indent))}.join}\n"

      when 'script','style'
        ""

      else
        "#{children.map{|child| mark_element(child,opts)}.join}"

      end
    end

  end
end
