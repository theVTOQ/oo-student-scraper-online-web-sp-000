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
    twitter = social_media[0]['href']
    linkedin = social_media[1]['href']
    github = social_media[2]['href']
    blog = social_media[3]['href']

    profile_quote = profile_page.css("div.vitals-text-container div.profile-quote").text
    bio = profile_page.css("div.details-container p").text

    scraped_student[:twitter] = twitter unless twitter == nil
    scraped_student[:linkedin] = linkedin unless twitter == nil
    scraped_student[:github] = github unless twitter == nil
    scraped_student[:blog] = blog
    scraped_student[:profile_quote] = profile_quote
    scraped_student[:bio] = bio
    scraped_student
  end
end

html = File.read("./fixtures/student-site/students/joe-burgess.html")
profile_page = Nokogiri::HTML(html)
social_media = profile_page.css("div.social-icon-container a")
puts social_media[0]
