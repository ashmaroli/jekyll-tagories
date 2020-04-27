Feature: Filter categorized items from given list of assorted items
  Scenario: Filter categorized posts
    Given I have the following posts:
      | title     | date       | categories | content           |
      | Episode 1 | 2009-03-07 | alpha      | Lorem ipsum       |
      | Episode 2 | 2009-03-14 |            | Dolor sit         |
      | Episode 3 | 2009-03-21 | beta       | Amet consectetur  |
      | Episode 4 | 2009-03-28 |            | Adipiscing elit   |
      | Episode 5 | 2009-04-04 | alpha      | Quisque dignissim |
      | Episode 6 | 2009-04-11 |            | Nisi a laoreet    |
      | Episode 7 | 2009-04-18 | beta       | Varius felis      |
      | Episode 8 | 2009-04-25 |            | Tortor vestibulum |
    And I have an include "item-list.html" with content:
      """
      {% if include.category %}
        {% assign items = site.posts | categorized: include.category %}
      {% else %}
        {% assign items = site.posts | categorized %}
      {% endif %}
      {% for item in items %}
        {{ item.title }}
      {% endfor %}
      """
    And I have a "categorized-posts.md" page that contains "{% include item-list.html %}"
    And I have a "posts-categorized-beta.md" page that contains "{% include item-list.html category='beta' %}"
    And I have a configuration file
    When I run jekyll build
    Then I should get a "_site" directory
    And I should get the expected contents in the generated "categorized-posts.html":
      | should contain | should not contain |
      | Episode 1      | Episode 2          |
      | Episode 3      | Episode 4          |
      | Episode 5      | Episode 6          |
      | Episode 7      | Episode 8          |
    And I should get the expected contents in the generated "posts-categorized-beta.html":
      | should contain | should not contain |
      | Episode 3      | Episode 1          |
      | Episode 7      | Episode 2          |
      |                | Episode 4          |
      |                | Episode 5          |
      |                | Episode 6          |
      |                | Episode 8          |

  Scenario: Filter categorized documents
    Given I have the following documents:
      | title     | collection | categories | content           |
      | Rover     | puppies    | alpha      | Lorem ipsum       |
      | Fido      | puppies    |            | Dolor sit         |
      | Tom       | kittens    | beta       | Amet consectetur  |
      | Daisy     | kittens    |            | Adipiscing elit   |
      | Hamburger | recipes    | alpha      | Quisque dignissim |
      | Cake      | recipes    |            | Nisi a laoreet    |
      | Birthday  | events     | beta       | Varius felis      |
      | Eclipse   | events     |            | Tortor vestibulum |
    And I have an include "item-list.html" with content:
      """
      {% if include.category %}
        {% assign items = site.documents | categorized: include.category %}
      {% else %}
        {% assign items = site.documents | categorized %}
      {% endif %}
      {% for item in items %}
        {{ item.title }}
      {% endfor %}
      """
    And I have a "categorized-documents.md" page that contains "{% include item-list.html %}"
    And I have a "documents-categorized-beta.md" page that contains "{% include item-list.html category='beta' %}"
    And I have a configuration file with:
      | collections | [puppies, kittens, recipes, events] |
    When I run jekyll build
    Then I should get a "_site" directory
    And I should get the expected contents in the generated "categorized-documents.html":
      | should contain | should not contain |
      | Rover          | Fido               |
      | Tom            | Daisy              |
      | Hamburger      | Cake               |
      | Birthday       | Eclipse            |
    And I should get the expected contents in the generated "documents-categorized-beta.html":
      | should contain | should not contain |
      | Tom            | Rover              |
      | Birthday       | Fido               |
      |                | Daisy              |
      |                | Hamburger          |
      |                | Cake               |
      |                | Eclipse            |
