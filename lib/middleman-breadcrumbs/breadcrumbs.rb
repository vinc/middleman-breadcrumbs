require 'middleman'
require File.join(File.dirname(__FILE__), 'version')
require 'rack/utils'
require 'padrino-helpers'

class Breadcrumbs < Middleman::Extension
  include BreadcrumbsVersion
  include Padrino::Helpers

  option :separator, ' > ', 'Default separator between breadcrumb levels'
  option :wrapper, nil, 'Name of tag (as symbol) in which to wrap each breadcrumb level, or nil for no wrapping'

  expose_to_template :breadcrumbs

  def initialize(app, options_hash = {}, &block)
    super
    @separator = options.separator
    @wrapper = options.wrapper
  end

  def breadcrumbs(page, separator: @separator, wrapper: @wrapper)
    hierarchy = [page]
    hierarchy.unshift(hierarchy.first.parent) while hierarchy.first.parent
    hierarchy.collect { |parent| wrap(pretty_link_to(parent), wrapper: wrapper) }.join(escape_html(separator))
  end

  private

  def pretty_link_to(page)
    link_to(page.data.title, URI(page.url).path)
  end

  def wrap(content, wrapper: nil)
    wrapper ? content_tag(wrapper) { content } : content
  end
end
