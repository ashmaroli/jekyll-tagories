Feature: Jekyll site with enhanced tags and categories payload

  Scenario: Basic site with some posts
    Given I have a "tags.md" page that contains "{% include nested-list.html data=site.tags %}"
    And I have a "categories.md" page that contains "{% include nested-list.html data=site.categories %}"
    And I have an include "nested-list.html" with content:
      """
      <ul>
      {% for entry in include.data %}
        <li id="{{ entry[0] }}">
          <ul>
          {% for doc in entry[1] %}
            <li>{{ doc.url }}</li>
          {% endfor %}
          </ul>
        </li>
      {% endfor %}
      </ul>
      """
    And I have the following posts:
      | title     | date       | tags   | categories | content     |
      | Episode 1 | 2009-03-20 | simple |            | Hello World |
      | Episode 2 | 2009-03-27 |        | alpha beta | Whatever... |
    When I run jekyll build
    Then I should get a "_site" directory
    And I should get the expected contents in the generated "tags.html":
      | should contain                      | should not contain                  |
      | <li id="simple">                    | <li>/2009/03/27/episode-2.html</li> |
      | <li>/2009/03/20/episode-1.html</li> |                                     |
    And I should get the expected contents in the generated "categories.html":
      | should contain                                  | should not contain                  |
      | <li id="alpha">                                 | <li>/2009/03/27/episode-1.html</li> |
      | <li id="beta">                                  |                                     |
      | <li>/alpha/beta/2009/03/27/episode-2.html</li>  |                                     |

  Scenario: Site posts and collections
    Given I have a "tags.md" page that contains "{% include nested-list.html data=site.tags %}"
    And I have a "categories.md" page that contains "{% include nested-list.html data=site.categories %}"
    And I have an include "nested-list.html" with content:
      """
      <ul>
      {% for entry in include.data %}
        <li id="{{ entry[0] }}">
          <ul>
          {% for doc in entry[1] %}
            <li>{{ doc.url }}</li>
          {% endfor %}
          </ul>
        </li>
      {% endfor %}
      </ul>
      """
    And I have the following posts:
      | title     | date       | tags   | categories | content     |
      | Episode 1 | 2009-03-20 | simple |            | Hello World |
      | Episode 2 | 2009-03-27 |        | alpha beta | Whatever... |
    And I have the following documents:
      | title     | collection | tags      | categories | content         |
      | Rover     | puppies    | simple    | alpha      | Woof..!         |
      | Fido      | puppies    | simple    | beta       | Woof..! Woof..! |
      | Cake      | recipes    | dessert   | beta       | Happy Birthday! |
      | Hamburger | recipes    | fast-food | alpha      | Patties n Mayo  |
    And I have a configuration file with:
      | collections | [puppies, recipes] |
    When I run jekyll build
    Then I should get a "_site" directory
    And I should get the expected contents in the generated "tags.html":
      | should contain                      | should not contain                  |
      | <li id="simple">                    | <li>/2009/03/27/episode-2.html</li> |
      | <li id="dessert">                   |                                     |
      | <li id="fast-food">                 |                                     |
      | <li>/2009/03/20/episode-1.html</li> |                                     |
      | <li>/recipes/cake.html</li>         |                                     |
      | <li>/recipes/hamburger.html</li>    |                                     |
    And I should get the expected contents in the generated "categories.html":
      | should contain                                 | should not contain                  |
      | <li id="alpha">                                | <li>/2009/03/27/episode-1.html</li> |
      | <li id="beta">                                 |                                     |
      | <li>/alpha/beta/2009/03/27/episode-2.html</li> |                                     |
      | <li>/puppies/fido.html</li>                    |                                     |
      | <li>/puppies/rover.html</li>                   |                                     |
      | <li>/recipes/cake.html</li>                    |                                     |
      | <li>/recipes/hamburger.html</li>               |                                     |
