require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = []
    html = File.read(index_url)
    index_page = Nokogiri::HTML(html)
    index_page.css("div.student-card a").each do |student_card|
      name = student_card.css("div.card-text-container h4").text
      location = student_card.css("div.card-text-container p").text
      profile_url = student_card['href']
      students << {name: name, location: location, profile_url: profile_url}
    end

    students
  end

  def self.scrape_profile_page(profile_url)
    scraped_student = {}
    html = File.read(profile_url)
    profile_page = Nokogiri::HTML(html)
    social_media = profile_page.css("div.social-icon-container a")
    possible_sites = ["linkedin", "github", "twitter"]
    social_media.each do |site|
      site_link = site['href']
      #if the site name starts with "www.":
      site_name = site_link[/#{"www."}(.*?)#{".com"}/m, 1]
      if site_name == nil
        #if the site name starts with "https://" or even "//":
        site_name = site_link[/#{"\/\/"}(.*?)#{".com"}/m, 1]
      elsif !possible_sites.include?(site_name)
        #if this is a blog, this conditional should evaluate to true,
        #in which case, we must set the key to "blog"
        site_name =  "blog"
      end
      binding.pry
      scraped_student[site_name.to_sym] = site_link
    end

    profile_quote = profile_page.css("div.vitals-text-container div.profile-quote").text
    bio = profile_page.css("div.details-container p").text

    scraped_student[:profile_quote] = profile_quote
    scraped_student[:bio] = bio
    scraped_student
  end
end
