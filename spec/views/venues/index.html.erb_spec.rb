require 'rails_helper'

RSpec.describe "venues/index", type: :view do
  before(:each) do
    assign(:venues, [
      Venue.create!(
        :name => "Name",
        :description => "MyText",
        :category => 2,
        :latitude => 3.5,
        :longitude => 4.5
      ),
      Venue.create!(
        :name => "Name",
        :description => "MyText",
        :category => 2,
        :latitude => 3.5,
        :longitude => 4.5
      )
    ])
  end

  it "renders a list of venues" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.5.to_s, :count => 2
    assert_select "tr>td", :text => 4.5.to_s, :count => 2
  end
end
