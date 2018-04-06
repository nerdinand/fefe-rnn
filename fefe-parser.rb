require 'mechanize'
require 'pry-byebug'

agent = Mechanize.new

years = [2015, 2016, 2017, 2018]
months = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']

years.each do |year|
  months.each do |month|
    url = "https://blog.fefe.de/?mon=#{year}#{month}"
    page = agent.get(url)

    puts url

    page.search('/html/body/ul/li').each do |post|
      first_link = post.search('a').first

      next if first_link.nil?

      post_id = first_link[:href].split('=').last

      File.open("fefe/#{post_id}", 'w') do |file|
        text = post.text.gsub('ä', 'ae').gsub('ö', 'oe').gsub('ü', 'ue').gsub('ß', 'ss')
        file.write text
      end
    end
  end
end
