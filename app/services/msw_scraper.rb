require 'mechanize'
require 'nokogiri'
require './app/services/constant.rb'

class MswScraper
  attr_reader :full_data

  def initialize(region = Constant.new_england)
    @url_base = "http://www.magicseaweed.com"
    @scrape_url = build_url(region)
    @full_data = Hash.new
  end

  def scrape_region
    mech = Mechanize.new

    # this is not a scraper
    mech.user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36'
    region_info = mech.get(@scrape_url)
    sub_regions = region_info.links.select { |l| l.text =~ /a*\s\d+\sspots/ }
    sub_region_links = sub_regions.map { |l| build_url("forecast" + l.uri.path) }
    sub_region_links.each do |link|
      sub_region_name = beach_name(link)
      @full_data[sub_region_name] = Hash.new
      @full_data[sub_region_name]["id"] = get_id(link)
      @full_data[sub_region_name]["url"] = link
      sub_beaches = generate_surfcast_urls(mech.get(link).links)
      sub_beaches.each do |beach_link|

        # unless you want to surf in the center of the atlantic, lets just not save this guy
        unless beach_link == "http://www.magicseaweed.com/New-England-Hurricane-Surf-Report/1095/"
          name = beach_name(beach_link)
          @full_data[sub_region_name][name] = Hash.new
          @full_data[sub_region_name][name]["url"] = beach_link
          @full_data[sub_region_name][name]["id"] = get_id(beach_link)
        end
      end
      sleep 2
    end

  end

  private

  def get_id(link)
    (link.reverse.match('\d+')[0]).reverse if link.reverse.match('\d+')
  end

  def beach_name(link)
    if link =~ /forecast/
      (link[/forecast\/(.+)\/\d{1,5}/, 1]).gsub("-", " ")
    elsif link =~ /-Surf-Report/
      (link[/seaweed.com\/(.*)-Surf-Report\/\d{1,5}/, 1]).gsub("-", " ")
    else
      nil
    end
  end

  def generate_surfcast_urls(sub_regions_array)
    urls = Array.new
    urls = sub_regions_array.select do |region|
      if region.uri.nil?
        false
      else
        region.uri.path =~ /-Surf-Report\//
      end
    end
    urls.map {|url| build_url(url.href[1..-1])}
  end

  def build_url(path)
    if path.class != {}.class
      @url_base + "/" + path.to_s
    else
      @url_base + "/" + path[:name] + "/" + path[:id]
    end
  end
end
