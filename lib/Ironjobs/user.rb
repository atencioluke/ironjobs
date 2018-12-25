class Ironjobs::User

    attr_accessor :name, :title, :location, :job, :language, :schedule, :list

    def initialize(name, title, location="boston", language)
        @name = name
        @title = title
        @location = location
        @language = language
        @list = []
        @recent_fetch = nil
    end

    def user_profile
        [@name, @title, @location, @language]
    # system "clear"
    #    puts " "
    #    puts "   Name: #{@name}".blue
    #    puts "   Desired Job: #{@title}".blue
    #    puts "   Location: #{@location}".blue
    #    puts "   Favorite Programming Language: #{@language}".blue
    #    puts " "
    end

    def fetch_by_profile
        @recent_fetch = Ironjobs::API.fetch(@language,@location,"YES")
        counter = 1
        out = []
        @recent_fetch.each do |job|
            out << "#{counter}. #{job["title"]}"
            counter += 1
        end
        out
    end

    def save(job)
        @list << job
    end
end