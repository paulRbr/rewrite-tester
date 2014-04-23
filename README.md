Rewrite Tester
===

This tool provides Rspec integration tests to test your server's *url rewriting* capabilities given a set of Apache `RewriteRules`.


_Tool under development_

Usage
===

- From the sources

    - Clone the repository and use the default rake task to run the tests. You will need to give the absolute path of a file containing a list of `RewriteRules` through a `RULES` env variable. Additionally you will need to provide a `HTTP_HOST` env variable, containing the host that you are testing against.

    ```bash
    $ HTTP_HOST=www.example.com RULES=/path/to//my/rules rake try:redirects
    ```
    
- From your project

    - Include the gem in your `Gemfile`

    ```ruby
    gem 'rewrite-tester'
    ```

    - Use the `test:redirects` rake task by giving a absolute file path to the `RULES` env variable.

    ```bash
    $ HTTP_HOST=www.example.com RULES=/path/to//my/rules rake try:redirects
    ```
    
LICENSE
===

MIT
