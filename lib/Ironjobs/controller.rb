class Ironjobs::Controller

    attr_accessor :active_user

    def call
        self.welcome
    end

    def initialize
        @active_user = nil
    end

    def help
        list = ["View or alter your profile",
            "View your list of saved jobs",
            "Search for a specific job",
            "Search for a job based off of your profile",
            "View your history of job searches",
            "exit"]
        prompt = TTY::Prompt.new
        input = prompt.select("Select command using arrow keys and press enter!".light_blue, list)
        case input
        when list[0]
            self.user_profile
        when list[1]
            self.user_joblist
        when list[2]
            self.search
        when list[3]
            self.list(@active_user.fetch_by_profile)
        when list[4]
            self.history
        when list[5]
            self.exit
        end
    end

    ##call puts in this method, not the user class
    def user_profile
        @active_user.user_profile
        prompt = TTY::Prompt.new
        input = prompt.select("You can go back to the help menu or exit the proram.", ["Help menu", "Exit program"])
        case input
        when "Help menu"
            self.help
        when "exit program"
            self.exit
        end
    end
   
    def history
        if Ironjobs::Jobs.all.length == 0
            system "clear"
            puts "
            You don't have any saved jobs yet!
            
            ".light_blue
            self.help
        else
            system "clear"
            ##Define the prompt gem instance in an instance variable
            prompt = TTY::Prompt.new
            input = prompt.select("Select command using arrow keys and press enter!".light_blue, Ironjobs::Jobs.all.map {|i| i.title})
            job_expand(input)
        end
    end

    def initiate
        # puts "What is your name?"
        # name = gets.chomp
        # puts "Okay, #{name.green}. What is your dream job title?"
        # title = gets.chomp.to_s
        # puts "#{randomize("!")} What's the nearest major city?"
        # location = gets.chomp.to_s
        # puts "Finally, what's your favorite programming language?"
        # language = gets.chomp.to_s
        # new_user(name, title, location, language)
        new_user("Matthew", "Software Engineer", "Boston", "Python")
        system "clear"
        help
    end

    def new_user(name, title, location, language)
        @active_user = Ironjobs::User.new(name, title, location, language)
    end

    def search 
        system "clear"
            puts "You can search through our database of jobs using programming language, job location, and schedule!".light_blue
            puts "**NOTE** If you don't want to specify one of these options, just enter 'skip'.".light_blue
            puts "What programming language should the position use?".light_blue
            language = gets.chomp.to_s
            puts "Where do you want to look?"
            location = gets.chomp.to_s
            puts "Do you want it to be full time?"
            full_time = gets.chomp.to_s.upcase
        list(Ironjobs::Jobs.fetch_by_search(language,location,full_time))
    end

    def list(fetch)
        binding.pry
        input = self.prompt("Select job using arrow keys and press enter!", fetch)

        job_expand(input)
    end

    def job_expand(input)
        input = input.split('').first.to_i
        system "clear"
        if (0..Ironjobs::API.list.length).include?(input)
            job = Ironjobs::Jobs.create_job(Ironjobs::API.list, input)
                puts "Title: ".light_blue + job.job_profile[0]
                puts "Company: ".light_blue + job.job_profile[1]
                puts "Location: ".light_blue + job.job_profile[2]
                puts "Schedule: ".light_blue + job.job_profile[3]
                puts "Description: ".light_blue + job.job_profile[4]
            self.save(job)
        end
    end

    def user_joblist
        job = self.prompt("Select job using arrow keys and press enter!", @active_user.list.map {|i| i.title})
        self.job_expand(job)
    end

    def save(job)
        puts "<-------------------------------------------------------------------------------------->".red
        response = self.prompt("Save to store this job on your profile OR help to go back to the main menu.".light_blue, ['Save','Help'])
        if response == 'Save'
            @active_user.save(job)
            system "clear"
            self.help
        else response == 'Help'
            system "clear"
            self.help
        end
    end

    def randomize(type)
        if type == "!"
            words = ["Fantastic!", "Outstanding!", "Incredible!", "Great!", "Very nice...", "Exceptional."]
            words[rand(words.length-1)]
        end
    end

    def prompt(string, array)
        prompt = TTY::Prompt.new
        prompt.select(string, array)
    end

    ## Welcome and exit message methods

    def welcome
        system "clear"
        puts "        
      +-+-+-+-+-+-+-+-+
      |I|r|o|n|j|o|b|s|
      +-+-+-+-+-+-+-+-+
        
           WELCOME
             
             ".light_blue
        puts "--------------------------------"
        puts "This application will allow you
 to search through a well kept
  database of up to date job
          offerings!
        
    Before we get started...
      introduce yourself!".light_blue
        puts "--------------------------------"
        self.initiate
    end

    def exit
        system "clear"
        puts "Singing off. Thank you for using Ironjobs!".green
    end
end