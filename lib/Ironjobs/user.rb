class Ironjobs::User

    attr_accessor :name, :title, :location, :job, :language, :schedule, :list
    @@user = nil

    def initialize(name, title, location="boston", language)
        @name = name
        @title = title
        @location = location
        @language = language
        @list = []
        @@user = self
    end

    def profile
    system "clear"
       puts " "
       puts "   Name: #{@name}".blue
       puts "   Desired Job: #{@title}".blue
       puts "   Location: #{@location}".blue
       puts "   Favorite Programming Language: #{@language}".blue
       puts " "
    end

    def fetch_by_profile
        Ironjobs::API.fetch(@language,@location,"YES")
        data = open("https://jobs.github.com/positions.json?description=#{Ironjobs::User.user.language}&full_time=true&location=#{Ironjobs::User.user.location}").read
        @@list = JSON.parse(data)
        counter = 1
        out = []
        @@list.each do |job|
            out << "#{counter}. #{job["title"]}"
            counter += 1
        end
        out
    end

    def self.user
        @@user
    end

    def save(job)
        @list << job
    end

    def search 
    end
end