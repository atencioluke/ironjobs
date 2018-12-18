

class Ironjobs::Jobs
    # extend Search
    @@list = nil
    
    def self.list
        @@list
    end

    def self.fetch(language="python",location="boston",schedule="true")
        desc = "description=#{language}"
        sched = "&full_time=#{schedule == "true" ? true : false}"
        loc = "&location=#{location}"
        data = open("https://jobs.github.com/positions.json?#{desc}#{sched}#{loc}").read
        @@list = JSON.parse(data)
        counter = 1
        @@list.each do |job|
            puts "#{counter}. #{job["title"]}"
            counter += 1
        end
    end

    def self.search_by_language(language="javascript")  
        data = open("https://jobs.github.com/positions.json?description=#{language}").read
        @@list = JSON.parse(data)
        @@list.each do |job|
            puts job
        end
    end

    def self.search_by_location(location="boston")
        data = open("https://jobs.github.com/positions.json?location=#{location}").read
        @@list = JSON.parse(data)
        @@list.each do |job|
            puts job
        end
    end

    def self.search_by_profile
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

    def self.job_expand(input)
        if (0..@@list.length).include?(input-1)
            system "clear"
            puts "#{"Job Title:".green} #{@@list[input-1]["title"]}"
            puts "#{"Company:".green} #{@@list[input-1]["company"]}"
            puts "#{"Job Location:".green} #{@@list[input-1]["location"]}"
            puts "#{"Schedule:".green} #{@@list[input-1]["type"]}"
            puts "#{"Description:".green} #{@@list[input-1]["description"].gsub(/<\/?[^>]*>/, "")}"
        end
    end


end