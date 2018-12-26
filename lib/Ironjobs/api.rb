class Ironjobs::API

    #The fetch method will retrieve the initial data from the GitHub Jobs using keyword replacements for the API link.
    #   The method returns parsed JSON data that can be manipulated.
    def self.fetch(language="python",location="boston",full_time="YES")
        desc = "description=#{language}"
        sched = "&full_time=#{full_time == "YES" ? true : false}"
        loc = "&location=#{location}"
        data = open("https://jobs.github.com/positions.json?#{desc}#{sched}#{loc}").read
        @@list = JSON.parse(data)
    end
end