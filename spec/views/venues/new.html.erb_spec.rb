require 'rails_helper'

RSpec.describe "venues/new", type: :view do
  before(:each) do
    assign(:venue, Venue.new(
      :name => "MyString",
      :description => "MyText",
      :category => 1,
      :latitude => 1.5,
      :longitude => 1.5
    ))
  end

  it "renders new venue form" do
    render

    assert_select "form[action=?][method=?]", venues_path, "post" do

      assert_select "input#venue_name[name=?]", "venue[name]"

      assert_select "textarea#venue_description[name=?]", "venue[description]"

      assert_select "input#venue_category[name=?]", "venue[category]"

      assert_select "input#venue_latitude[name=?]", "venue[latitude]"

      assert_select "input#venue_longitude[name=?]", "venue[longitude]"
    end
  end
end
