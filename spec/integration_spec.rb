lib_path = File.join(File.dirname(__FILE__), '../lib/')
$LOAD_PATH << lib_path
require 'tree_structure_digest'

describe "tree_structure_digest" do

  def digest_fixture(file, opts={})
    TreeStructureDigest::Digest.new(opts).injest_yml_files(
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
.address.city
.address.postalCode
.address.state
.address.streetAddress
.age
.firstName
.lastName
.phoneNumbers[].number
.phoneNumbers[].type
HEREDOC
  end

  it "works with JSON in tree format" do
    digest_fixture("sample.json", tree: true).should == <<HEREDOC.chomp
.address
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
HEREDOC
  end
end
