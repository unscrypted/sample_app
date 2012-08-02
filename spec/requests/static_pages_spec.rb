require 'spec_helper'

describe "Static pages" do
  
  let (:base_title) { "Ruby on Rails Tutorial Sample App" }

  subject { page }

  describe "Home page" do
    
    before { visit root_path }

    it { should have_selector('h1', text: 'Sample App') }
    it { should have_selector('title', text: full_title('')) }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Loren ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end
    end

  end

  describe "Help page" do

    before { visit help_path }

  	it { page.should have_selector('h1', text: 'Help') }
    it { page.should have_selector('title', text: full_title('Help')) }

	end

	describe "About page" do

    before { visit about_path }

  	it { page.should have_selector('h1', text: 'About Us') }
    it { page.should have_selector('title', text: full_title('About Us')) }

	end

  describe "Contact page" do

    before { visit contact_path }

    it { page.should have_selector('h1', text: 'Contact Us') }
    it { page.should have_selector('title', text: full_title('Contact Us')) }
    
  end

end
