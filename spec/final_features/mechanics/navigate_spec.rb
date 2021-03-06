require 'rails_helper'

feature 'navigation', js: true do
  scenario 'using navigation links' do
    When 'a user visits the site' do
      visit('/')
    end

    Then 'they are greeted with the plain landing page' do
      wait_for { focus_on(:nav).brand }.to eq 'Game'
      wait_for { focus_on(:nav).nav_links }.to eq ['Sign in', 'Register']
    end

    When 'they click on register' do
      focus_on(:nav).follow_nav_link('Register')
    end

    Then 'they are taken to the register page' do
      wait_for { page.current_path }.to eq('/register')
    end

    When 'the click on the brand Game link' do
      focus_on(:nav).follow_brand_link
    end

    Then 'they go back to the landing page' do
      wait_for { focus_on(:nav).brand }.to eq 'Game'
    end

    When 'they click sign in' do
      focus_on(:nav).follow_nav_link('Sign in')
    end

    Then 'they are taken to the sign in page' do
      wait_for { page.current_path }.to eq('/sign_in')
    end
  end

  context 'Given a user is registered and signed in' do
    before do
      create_and_login_as(handle: 'COQ')
    end

    scenario 'using navigation links' do
      When 'a user visits the site' do
        visit('/')
      end

      Then 'they are logged in to the game page' do
        wait_for { focus_on(:page_content).container_for('home').heading }.to eq('Play with me?')
        wait_for { focus_on(:nav).nav_links }.to eq ['COQ']
      end

      When 'the click on the brand Game link' do
        focus_on(:nav).follow_brand_link
      end

      Then 'they go back to the landing page' do
        wait_for { focus_on(:nav).brand }.to eq 'Game'
      end
    end
  end

  context 'mobile width' do
    before do
      visit('/')
      @browser_window_size = page.driver.browser.manage.window.size
      page.driver.browser.manage.window.resize_to(767, 768)
    end

    after do
      page.driver.browser.manage.window.resize_to(@browser_window_size.width, @browser_window_size.height)
    end

    scenario 'all navigation links are accessible' do
      When 'a user visits the site' do
        visit('/')
      end

      Then 'navigation is hidden apart from brand and hamburger' do
        wait_for { focus_on(:nav).brand }.to eq 'Game'
        wait_for { focus_on(:nav).nav_links }.to eq %w[]
      end

      When 'user expands the hamburger' do
        focus_on(:nav).toggle_hamburger
      end

      Then 'the navigation to sign in and register appears' do
        wait_for { focus_on(:nav).brand }.to eq 'Game'
        wait_for { focus_on(:nav).nav_links }.to eq ['Sign in', 'Register']
      end
    end

    scenario 'Sign in link taken users to the sign in page' do
      When 'a user visits follows the sign in link' do
        visit('/')
        focus_on(:nav).toggle_hamburger
        focus_on(:nav).follow_nav_link('Sign in')
      end

      Then 'sign in page is rendered' do
        wait_for { focus_on(:page_content).container_for('sign-in').heading }.to eq('Sign In')
      end
    end

    scenario 'register link taken users to the register page' do
      When 'a user visits follows the sign in link' do
        visit('/')
        focus_on(:nav).toggle_hamburger
        focus_on(:nav).follow_nav_link('Register')
      end

      Then 'register page is rendered' do
        wait_for do
          focus_on(:page_content).container_for('register').heading
        end.to eq('Register')
      end
    end
  end
end
