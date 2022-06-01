#!/usr/bin/env ruby

# file: jofh22.rb

# description: Jobs Online form helper 2022 (Experimental)

require 'yaml'
require 'ferrumwizard'


module Jofh22

  class NHSScot

    attr_reader :browser

    # notes:
    #
    #   * the *cookies* parameter can reference a file path to save or
    #     read a cookie file
    #   * the *yml* parameter refeference the YAML file containing the inputs
    #
    def initialize(yml='/tmp/tmp.yaml', ofh22_filepath=nil,
                   cookies: nil, debug: false)

      @cookies, @debug = cookies, debug
      ofh22_filepath ||= File.join(File.dirname(__FILE__), '..', 'data',
                                   'nhs_scot.yaml')
      url = 'https://apply.jobs.scot.nhs.uk/register.aspx'
      cookies2 = cookies if File.exists? cookies
      @browser = browser = FerrumWizard.new(url,  headless: false,
                                            cookies: cookies2)
      sleep 1

      filepath = yml
      @h = YAML.load(File.read(filepath))

      if not @h['home_telephone'].to_s[0] == '+' then
        @h['home_telephone'] = '+' + @h['home_telephone'].to_s
      end

      @ofh22 = YAML.load(File.read(ofh22_filepath))

    end

    # used for the registration process for new applicants
    #
    def populate_form(cookie_filepath=@cookies)

      @ofh22.each do |key, x|

        if @debug then
          puts 'key: ' + key.inspect
          puts 'x: ' + x.inspect
        end

        type, xpath = x

        if type == :input or type == :select then
          @browser.method(type).call(xpath, @h[key.to_s])
        elsif type == :click
          @browser.method(type).call(xpath)
        end

      end

      @browser.save_cookies(cookie_filepath)
      puts 'cookies saved to ' + cookie_filepath

    end

    def to_h()
      @h
    end

    def to_ofh22()
      @ofh22
    end

  end

end
