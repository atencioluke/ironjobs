

class Ironjobs::Jobs
    # extend Search

    attr_accessor :title, :company, :location, :schedule, :description, :recent_fetch
    @@all = []
    # @@list = []

    # def self.list
    #     @@list 
    # end
    # def self.list=(list)
    #     @@list = list
    # end
    def initialize(title, company=nil, location=nil, schedule=nil, description=nil)
        @title = title
        @company = company if company != nil
        @location = location if location != nil
        @schedule = schedule if schedule != nil
        @description = description if description != nil
        @recent_fetch = nil
        @@all << self if !@@all.include?(self)
    end

    def self.all
        @@all
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

    def self.create_job(list,input)
        title = list[input]["title"]
        company = list[input]["company"]
        location = list[input]["location"]
        type = list[input]["type"]
        description = list[input]["description"].gsub(/<\/?[^>]*>/, "")
        Ironjobs::Jobs.new(title, company, location, type, description)
    end

    def job_profile
        [@title, @company, @location, @schedule, @description]
    end
    
end