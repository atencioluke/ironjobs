class Ironjobs::User

    attr_accessor :name, :title, :location, :job, :language, :schedule, :list

    def initialize(name, title, location, language)
        @name = name
        @title = title
        @location = location
        @language = language
        @list = []
        @recent_fetch = nil
    end

    def user_profile
        [@name, @title, @location, @language]
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