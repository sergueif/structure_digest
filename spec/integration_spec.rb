lib_path = File.join(File.dirname(__FILE__), '../lib/')
$LOAD_PATH << lib_path
require 'structure_digest'

describe "structure_digest" do

  def digest_fixture(file, opts={})
    StructureDigest::Digest.new(opts).injest_yml_files(
      [File.expand_path("./fixtures/#{file}", File.dirname(__FILE__))]
    ).shorthand
  end

  it "works with yml" do
    digest_fixture("sample.yml").should == <<HEREDOC.chomp
.bill-to.city
.bill-to.state
.bill-to.street
.customer.family
.customer.given
.date
.items[].descrip
.items[].part_no
.items[].price
.items[].quantity
.items[].size
.problem.return
.receipt
.recursive.problem.ans
.recursive.problem.que
.recursive.problem2.ans
.recursive.problem2.que
.ship-to.city
.ship-to.state
.ship-to.street
.specialDelivery
HEREDOC
  end

  it "works with JSON" do
    digest_fixture("sample.json").should == <<HEREDOC.chomp
.address.box
.address.city
.address.postalCode
.address.state
.address.streetAddress
.age
.firstName
.lastName
.phoneNumbers[].number
.phoneNumbers[].type
.stuff
HEREDOC
  end

  it "works with JSON in tree format" do
    digest_fixture("sample.json", tree: true).should == <<HEREDOC.chomp
.address
  .box
  .city
  .postalCode
  .state
  .streetAddress
.age
.firstName
.lastName
.phoneNumbers[]
  .number
  .type
.stuff
HEREDOC
  end

  it "works as a diff library" do
    h1 = {
      a: 1,
      b: [{
        c: 4,
        d: 5
      },
      {
        e: 6,
        f: []
      },
      3
      ]
    }
    h2 = {
      b: [{
        c: 4,
        d: 8,
        f: 6
      },
      {
        e: 9
      },
      3,
      {}
      ]
    }

    diff = StructureDigest::Digest.diff(h1, h2)
    expect(diff).to eq([
      "- .a=1", "- .b[0].d=5", "+ .b[0].d=8", "+ .b[0].f=6", "- .b[1].e=6", "+ .b[1].e=9", "- .b[1].f=[]", "+ .b[3]={}"
    ])
  end
end
