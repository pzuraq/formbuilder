# Getting Started

You will need [Vagrant](http://www.vagrantup.com/) installed.

- Clone the repo
- Run `vagrant up` in the repo directory
- Run `vagrant ssh` -> `cd /vagrant` -> `bundle install`. This installs all of the rails dependencies on the VM.
- After bundler completes, run `rake db:migrate`. This typically performs any migrations (database changes) that haven’t been completed yet. Right now there is only one, it enables HSTOREs.
- Finally, run `bundle exec rails s`. This will start the rails server.
- On your browser go to http://localhost:3000/, you should see the rails welcome page.

# Test Template

We will be using this for template testing:

```
{{#section}}
  {{#question name="question1"}}
    {{#label}}This is the first question!{{/label}}
    {{#radio value="1"}}Hooray!{{/radio}}
    {{#radio value="0"}}Boo >:({{/radio}}
  {{/question}}
{{/section}}

{{#section}}
  {{#question name="question2"}}
    {{#label}}This is the second question! Would you like a followup?{{/label}}
    {{#radio value="1"}}Yes!{{/radio}}
    {{#radio value="0"}}No >:({{/radio}}
  {{/question}}

  {{#branch if="question2=1"}}
    {{#section}}
      {{#question name="question3"}}
        {{#label}}This is a followup question!{{/label}}
        {{#radio value="1"}}Cool!{{/radio}}
        {{#radio value="0"}}It's alright I guess{{/radio}}
      {{/question}}
    {{/section}}
  {{/branch}}
{{/section}}

{{#section}}
  {{#question name="question4"}}
    {{#label}}Would you like to branch left or right?{{/label}}
    {{#radio value="left"}}Left!{{/radio}}
    {{#radio value="right"}}Right!{{/radio}}
  {{/question}}

  {{#branch if="question4=left"}}
    {{#section}}
      {{#question name="question5"}}
        {{#label}}This is the left branch!{{/label}}
        {{#radio value="1"}}I made the right choice{{/radio}}
        {{#radio value="0"}}I want a mulligan{{/radio}}
      {{/question}}
    {{/section}}
  {{/branch}}

  {{#branch if="question4=right"}}
    {{#section}}
      {{#question name="question6"}}
        {{#label}}This is the right branch! Want to branch again?{{/label}}
        {{#radio value="yes"}}Yessir!{{/radio}}
        {{#radio value="no"}}Nope >:({{/radio}}
      {{/question}}

      {{#branch if="question6=yes"}}
        {{#section}}
          {{#question name="question7"}}
            {{#label}}This is the right-left branch!{{/label}}
            {{#radio value="1"}}I LOVE IT!!!{{/radio}}
            {{#radio value="0"}}It's ok I guess{{/radio}}
          {{/question}}
        {{/section}}
      {{/branch}}

      {{#branch if="question6=no"}}
        {{#section}}
          {{#question name="question8"}}
            {{#label}}This is the right-right branch!{{/label}}
            {{#radio value="1"}}Legit{{/radio}}
            {{#radio value="0"}}Unlegit{{/radio}}
          {{/question}}
        {{/section}}
      {{/branch}}
    {{/section}}
  {{/branch}}
{{/section}}

{{#section}}
  {{#question name="question9"}}
    {{#label}}This is the final question!{{/label}}
    {{#radio value="1"}}Hooray!{{/radio}}
    {{#radio value="0"}}Finally.{{/radio}}
  {{/question}}
{{/section}}
```
