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
       puts @name
       puts "Aspiring #{@title}"
       puts @location
       puts "I love #{@language}"
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