# Jekyll Tagories

A Jekyll plugin that enhances `site.tags` and `site.categories` to include documents from user-defined collections and easily
*select* documents based on a given tag or category.

## Installation

Add `jekyll-tagories` to your `Gemfile` and then run `bundle install` on your terminal. However, if your site doesn't have
a Gemfile, you may install it directly by running `gem install jekyll-tagories`.

## Usage

To enable this plugin, add it to your configuration file before building your site:

```yaml
plugins:
  - jekyll-tagories
```

Once enabled, `{{ site.tags }}` and `{{ site.categories }}` will include documents from your collections if they have been
tagged or categorized via their front matter.

*Note: The support for categories are limited to just the document's front matter and will not consider a document's
superdirectories as categories like your posts.*

### Liquid filters

The plugin also exposes two Liquid filters to ease handling of the grouped pages and documents:

  * **`tagged`** &mdash; retrieve documents that are tagged.
    * **input:** an array of objects that have a `data` attribute.
    * **optional parameter:** a single tag name
    * **examples:**
      * `{{ site.recipes | tagged }}`
      * `{{ site.recipes | tagged: 'cake' }}`
  * **`categorized`** &mdash; retrieve documents that are categorized.
    * **input:** an array of objects that have a `data` attribute.
    * **optional parameter:** a single category name
    * **examples:**
      * `{{ site.recipes | categorized }}`
      * `{{ site.recipes | categorized: 'cakes' }}`
