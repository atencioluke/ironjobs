

class Ironjobs::Jobs
    # extend Search

    attr_accessor :title, :company, :location, :schedule, :description
    @@all = []

    def initialize(title, company=nil, location=nil, schedule=nil, description=nil)
        @title = title
        @company = company if company != nil
        @location = location if location != nil
        @schedule = schedule if schedule != nil
        @description = description if description != nil
        @@all << self if !@@all.include?(self)
    end

    def self.all
        @@all
    end
    # def self.create(title, company=nil, location=nil, schedule=nil, description=nil)
    #     job = self.new(title, company, location, schedule, description)
    # end

    def expand
            puts "<-------------------------------------------------------------------------------------->".red
            puts [
            "#{"Job Title:".green} #{@title}",
            "#{"Company:".green} #{@company}",
            "#{"Job Location:".green} #{@location}",
            "#{"Schedule:".green} #{@schedule}",
            "#{"Description:".green} #{@description.gsub(/<\/?[^>]*>/, "")}"
            ]
    end
    
end