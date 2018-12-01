require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = {}
    html = File.read(index_url)
    index_page = Nokogiri::HTML(html)
    index_page.css("div.student-card a div.card-text-container").each do |student_card|
      name = student_card.css("h4").text
      location = student_card.css("p").text
      students << {name: name, location: location}
    end

    students
  end

  def self.scrape_profile_page(profile_url)
    scraped_student = {}
    html = File.read(index_url)
    profile_page = Nokogiri::HTML(html)
    
    scraped_student
  end

end
