# Getting Started

You will need [Vagrant](http://www.vagrantup.com/) installed.

- Clone the repo
- Run `vagrant up` in the repo directory
- Run `vagrant ssh` -> `cd /vagrant` -> `bundle install`. This installs all of the rails dependencies on the VM.
- After bundler completes, run `rake db:migrate`. This typically performs any migrations (database changes) that haven’t been completed yet. Right now there is only one, it enables HSTOREs.
- Finally, run `bundle exec rails s`. This will start the rails server.
- On your browser go to http://localhost:3000/, you should see the rails welcome page.

# BRCA Template

```
{{#section}}
  {{#lead}}This questionnaire asks questions about your health and your family's health history. Your answers will help decide whether you might benefit from tests to check for certain gene mutations (especially BRCA) that increase risk of certain cancers.{{/lead}}

  {{#lead}}If you have already had such tests, this questionnaire is not for you.{{/lead}}

  {{#lead}}If you don't know the answers to the questions below, please try to collect that information and then talk with your doctor.{{/lead}}
{{/section}}

{{#section}}
  {{#question name="firstname"}}
    {{{textfield placeholder="First Name"}}}
  {{/question}}
  {{#question name="middlename" required="false"}}
    {{{textfield placeholder="Middle Name (optional)"}}}
  {{/question}}
  {{#question name="lastname"}}
    {{{textfield placeholder="Last Name"}}}
  {{/question}}
  {{#question name="birthdate"}}
    {{{datepicker placeholder="Birth Date"}}}
  {{/question}}
  {{#question name="phonenumber"}}
    {{{textfield placeholder="Phone Number"}}}
  {{/question}}
  {{#question name="email" required="false"}}
    {{{textfield placeholder="Email Address (optional)"}}}
  {{/question}}
{{/section}}
{{#section}}
  {{#question name="previousconditions" required="false"}}
    {{#label}}
      Please indicate any of the following conditions you have had:
    {{/label}}
    {{#checkbox}}
      {{#option value="had_thyroid_cancer"}}
        Thyroid cancer
      {{/option}}
      {{#option value="had_sarcoma"}}
        Sarcoma
      {{/option}}
      {{#option value="had_adrenal_cancer"}}
        Adrenal cancer
      {{/option}}
      {{#option value="had_cancer_of_the_uterus"}}
        Cancer of the uterus
      {{/option}}
      {{#option value="had_pancreatic_cancer"}}
        Pancreatic Cancer
      {{/option}}
      {{#option value="had_brain_tumors"}}
        Brain tumors
      {{/option}}
      {{#option value="had_stomach_cancer"}}
        Stomach cancer
      {{/option}}
      {{#option value="had_leukemia_or_lymphoma"}}
        Leukemia or lymphoma
      {{/option}}
    {{/checkbox}}
  {{/question}}
  {{#question name="hadovarian"}}
    {{#label}}
      Have you ever had ovarian cancer?
    {{/label}}
    {{#radio}}
      {{#option value="1"}}
        Yes
      {{/option}}
      {{#option value="0"}}
        No
      {{/option}}
    {{/radio}}
  {{/question}}
  {{#question name="relativeovarian"}}
    {{#label}}
      Have any of your close blood relatives ever had ovarian cancer?
    {{/label}}
    {{#radio}}
      {{#option value="1"}}
        Yes
      {{/option}}
      {{#option value="0"}}
        No
      {{/option}}
    {{/radio}}
  {{/question}}
{{/section}}

{{#section}}
  {{#question name="dcis"}}
    {{#label}}
      Have you ever had breast cancer or ductal carcinoma in situ (DCIS)?
    {{/label}}
    {{#radio}}
      {{#option value="1"}}
        Yes
      {{/option}}
      {{#option value="0"}}
        No
      {{/option}}
    {{/radio}}
  {{/question}}
  {{#followup if="ans.dcis==1"}}
    {{#question name="dcisagediagnosed"}}
      {{#label}}
        What was your age when your breast cancer was first diagnosed?
      {{/label}}
      {{#radio}}
        {{#option value="under50"}}
          Age 50 or under
        {{/option}}
        {{#option value="51orolder"}}
          Age 51 or older
        {{/option}}
      {{/radio}}
    {{/question}}
    {{#question name="dcistriplenegative"}}
      {{#label}}
        Was your cancer “triple negative”, without receptors for estrogen, progesterone and HER2?
      {{/label}}
      {{#radio}}
        {{#option value="1"}}
          Yes
        {{/option}}
        {{#option value="0"}}
          No
        {{/option}}
      {{/radio}}
    {{/question}}
    {{#question name="dcismultiplelocations"}}
      {{#label}}
        Was your cancer found in more than one location in the same breast?
      {{/label}}
      {{#radio}}
        {{#option value="1"}}
          Yes
        {{/option}}
        {{#option value="0"}}
          No
        {{/option}}
      {{/radio}}
    {{/question}}
    {{#question name="dcisbothbreasts"}}
      {{#label}}
        Have you had cancer in both breasts?
      {{/label}}
      {{#radio}}
        {{#option value="1"}}
          Yes
        {{/option}}
        {{#option value="0"}}
          No
        {{/option}}
      {{/radio}}
    {{/question}}
  {{/followup}}
{{/section}}

{{#section last="true"}}
  {{#question name="relativehasbrca"}}
    {{#label}}
      Have any close blood relatives been confirmed to have BRCA gene mutations?
    {{/label}}
    {{#radio}}
      {{#option value="1"}}
        Yes
      {{/option}}
      {{#option value="0"}}
        No
      {{/option}}
    {{/radio}}
  {{/question}}
  {{#question name="relativehadcancer"}}
    {{#label}}
      Have any close blood relatives had breast cancer?
    {{/label}}
    {{#radio}}
      {{#option value="1"}}
        Yes
      {{/option}}
      {{#option value="0"}}
        No
      {{/option}}
    {{/radio}}
  {{/question}}
  {{#followup if="ans.relativehadcancer==1"}}
    {{#question name="malecancer"}}
      {{#label}}
        Has any male blood relative had breast cancer?
      {{/label}}
      {{#radio}}
        {{#option value="1"}}
          Yes
        {{/option}}
        {{#option value="0"}}
          No
        {{/option}}
      {{/radio}}
    {{/question}}
    {{#question name="twoplus"}}
      {{#label}}
        Have two or more close blood relatives from the same side of your family had breast cancer?
      {{/label}}
      {{#radio}}
        {{#option value="1"}}
          Yes
        {{/option}}
        {{#option value="0"}}
          No
        {{/option}}
      {{/radio}}
    {{/question}}
  {{/followup}}
  {{#question name="relativeashkenazijewish"}}
    {{#label}}
      Is any close blood relative Ashkenazi Jewish? (Ashkenazi Jewish people have a higher chance of BRCA gene mutations.)
    {{/label}}
    {{#radio}}
      {{#option value="1"}}
        Yes
      {{/option}}
      {{#option value="0"}}
        No
      {{/option}}
    {{/radio}}
  {{/question}}
{{/section}}
```
