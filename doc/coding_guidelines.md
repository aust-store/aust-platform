=== Guidelines

*Code*

* ActiveRecord Models should not have any code related to the business logic,
only the sufficient for dealing with the database.
* Controllers should not have anything related to the business logic, but
only the sufficient for dealing with web requests.

*Git*

* Code and commit messages are written in english.
* Commits follow the format `[12341235] Commit title`
* Code is not pushed directly to master, except for fixing typos or
editing README. A PR is required.

*HTML/CSS/Javascript*

* Use `classes` to identify elements. Use `id` only when dealing with Javascript.

*Tests*

* Every story should have corresponding Acceptance tests
* Everything you write should have a Unit test
* If you write something that depends on Rails, like a `before_filter`, then
write an Integration test to assert that. You don't need to write Integrated 
to every controller.
