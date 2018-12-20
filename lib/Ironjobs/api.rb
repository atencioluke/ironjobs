class Ironjobs::API
    @@list = nil
    @@job = nil

    def self.list
        @@list
    end

    def self.job
        @@job
    end

    ##Fetches a list of jobs based off three parameters - language, location, and schedule.
    def self.fetch(language="python",location="boston",full_time="YES")
        desc = "description=#{language}"
        sched = "&full_time=#{full_time == "YES" ? true : false}"
        loc = "&location=#{location}"
        data = open("https://jobs.github.com/positions.json?#{desc}#{sched}#{loc}").read
        @@list = JSON.parse(data)
        counter = 1
        return @@list.collect do |job|
            job["title"]
        end
    end

    ##Fetches a list fo jobs based off the parameters saved in the user profile when someone first launched the app.
    def self.fetch_by_profile
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
        binding.pry
        if (0..@@list.length).include?(input-1)
            binding.pry
            title = @@list[input-=1]["title"]
            company = @@list[input]["company"]
            location = @@list[input]["location"]
            type = @@list[input]["type"]
            description = @@list[input]["description"].gsub(/<\/?[^>]*>/, "")
            Ironjobs::Jobs.new(title, company, location, type, description).expand
        end
    end
end