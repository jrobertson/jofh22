#!/usr/bin/env ruby

# file: jofh22.rb

# description: Jobs Online form helper 2022 (Experimental)

require 'yaml'
require 'ferrumwizard'
require 'nokorexi'


module Jofh22

  class NHSScot

    attr_reader :browser, :h, :doc

    # notes:
    #
    #   * the *cookies* parameter can reference a file path to save or
    #     read a cookie file
    #   * the *yml* parameter refeference the YAML file containing the inputs
    #
    def initialize(yml='/tmp/tmp.yaml', cookies: nil, debug: false)

      @debug = debug
      url = 'https://apply.jobs.scot.nhs.uk/register.aspx'
      @browser = browser = FerrumWizard.new(url,  headless: false,
                                            cookies: cookies)
      sleep 1
      @doc = Nokorexi.new(browser.body).to_doc
      sleep 1

      filepath = yml
      @h = YAML.load(File.read(filepath))

    end

    def populate_form()

      h, browser = @h, @browser
      r = browser.at_xpath('//select[@name="cmdTitle"]')

      # Title
      # options: , Councillor, Doctor, Father, Friar, Lady, Lord, Major,
      #            Miss, Mr., Mrs., Ms., Mx., Professor, Reverend, Sir
      title = h['title']
      titles = %w( Councillor Doctor Father Friar Lady Lord Major Miss Mr.) +
          %w(Mrs. Ms. Mx. Professor Reverend Sir)
      r = titles.grep /#{title}/i
      n = titles.index(r.first) + 1
      r = browser.at_xpath('//div[select/@name="cmdTitle"]')
      r.focus
      n.times { r.type(:down); sleep 0.4}
      r.click
      sleep 0.5

      r = browser.at_xpath('//input[@name="txtForename"]')

      # First name
      first_name = h['first_name']
      r.focus.type first_name
      sleep 0.5

      r = browser.at_xpath('//input[@name="txtSurname"]')

      # Last name
      last_name = h['last_name']
      r.focus.type last_name
      sleep 0.5

      r = browser.at_xpath('//input[@name="txtHomePostcode"]')

      # Postcode
      postcode = h['postcode']
      r.focus.type postcode
      sleep 0.5

      r = browser.at_xpath('//input[@name="txtHomeTelephone"]')

      # Home Telephone
      home_telephone = h['home_telephone']
      r.focus.type '+' + home_telephone.to_s.sub(/^\+/,'')
      sleep 0.5

      r = browser.at_xpath('//input[@name="recoveryOption"]')
      r.focus.click

      r = browser.at_xpath('//input[@name="txtHomeEmail"]')

      # Email address
      email_address = h['email_address']
      r.focus.type email_address
      sleep 0.5

      r = browser.at_xpath('//input[@name="txtPassword"]')

      # Password
      password = h['password']
      r.focus.type password
      sleep 0.5

      r = browser.at_xpath('//input[@name="txtPassword2"]')

      # Re-type password
      retype_password = h['retype_password']
      r.focus.type retype_password
      sleep 0.5

      r = browser.at_xpath('//select[@name="cmbEmployed"]')
      sleep 0.5
      # Are you currently employed by NHS Scotland?
      # options: Please select, Yes, No
      ayceb = h['ayceb']
      titles = ['Please select', 'Yes', 'No']
      puts 'ayceb: ' + ayceb.inspect if @debug
      puts 'titles: ' + titles.inspect if @debug

      r2 = titles.grep /#{ayceb}/i
      puts 'r2: ' + r2.inspect if @debug
      n = titles.index(r2.first) + 1
      r = browser.at_xpath('//div[select/@name="cmbEmployed"]')
      r.focus
      n.times { r.type(:down); sleep 0.4}
      r.click
      sleep 0.5

      r = browser.at_xpath('//input[@name="Termscheckbox"]')
      r.focus.click

      r = browser.at_xpath('//button[@type="submit"]')
      r.focus.click

      #r.focus.type(:enter)
      sleep 2
      browser.save_cookies(cookie_filepath)
      puts 'cookies saved to ' + cookie_filepath


    end

  end

end
