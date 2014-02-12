# StructureDigest

Run the binary with one or more YAML files to find out what it does


## Installation

Add this line to your application's Gemfile:

    gem 'structure_digest'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install structure_digest

## Usage

Given a sample YAML document from Wikipedia:

    ---
    receipt:     Oz-Ware Purchase Invoice
    date:        2012-08-06
    customer:
        given:   Dorothy
        family:  Gale

    items:
        - part_no:   A4786
          descrip:   Water Bucket (Filled)
          price:     1.47
          quantity:  4

        - part_no:   E1628
          descrip:   High Heeled "Ruby" Slippers
          size:      8
          price:     100.27
          quantity:  1

    bill-to:  &id001
        street: |
                123 Tornado Alley
                Suite 16
        city:   East Centerville
        state:  KS

    ship-to:  *id001

    specialDelivery:  >
        Follow the Yellow Brick
        Road to the Emerald City.
        Pay no attention to the
        man behind the curtain.

`structure_digest example.yml` will produce:

    .receipt
    .date
    .customer.given
    .customer.family
    .items[].part_no
    .items[].descrip
    .items[].price
    .items[].quantity
    .items[].size
    .bill-to.street
    .bill-to.city
    .bill-to.state
    .ship-to.street
    .ship-to.city
    .ship-to.state
    .specialDelivery

## Contributing

Could use a shorter name maybe

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
