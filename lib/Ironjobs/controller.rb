class Ironjobs::Controller

    def call
        self.welcome
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
            self.profile
        when list[1]
            puts Ironjobs::User.user.list
        when list[2]
            self.search
        when list[3]
            self.list(Ironjobs::API.fetch(Ironjobs::User.user.language,Ironjobs::User.user.location))
        when list[4]
            self.history
        when list[5]
            self.exit
        end
    end

    ##call puts in this method, not the user class
    def profile
        Ironjobs::User.user.profile
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
            puts "You don't have any saved jobs yet!
            
            ".light_blue
            self.help
        else
            system "clear"
            ##Define the prompt gem instance in an instance variable
            prompt = TTY::Prompt.new
            input = prompt.select("Select command using arrow keys and press enter!".light_blue, Ironjobs::Jobs.all.map {|i| i.title})
            expand(input)
        end
    end

    def initiate
        puts "What is your name?"
        name = gets.chomp
        puts "Okay, #{name.green}. What is your dream job title?"
        title = gets.chomp.to_s
        puts "#{randomize("!")} What's the nearest major city?"
        location = gets.chomp.to_s
        puts "Finally, what's your favorite programming language?"
        language = gets.chomp.to_s
        new_user(name, title, location, language)
        system "clear"
        help
    end

    def new_user(name, title, location, language)
        Ironjobs::User.new(name, title, location, language)
    end

    def search 
        system "clear"
        puts "You can search through our database of jobs using programming language, job location, and schedule!"
        puts "**NOTE** If you don't want to specify one of these options, just enter 'skip'."
        puts "What programming language should the position use?"
        language = gets.chomp.to_s
        puts "Where do you want to look?"
        location = gets.chomp.to_s
        puts "Do you want it to be full time?"
        full_time = gets.chomp.to_s.upcase
        list(Ironjobs::API.fetch(language,location,full_time))
    end

    def list(fetch)
        prompt = TTY::Prompt.new
        input = prompt.select("Select job using arrow keys and press enter!", fetch)
        expand(input)
    end

    def expand(input)
        system "clear"
        ##fix the below code
        job = Ironjobs::API.job_expand(input.split('').first.to_i).expand
        save?(job)
    end

    def save?(job)
        puts "If you want to save this job to your collection, enter 'save'. Otherwise, enter 'help'.".green
        puts "<-------------------------------------------------------------------------------------->".red
        response = gets.chomp.to_s
        if response == 'save'
            puts Ironjobs::User.user.save(job)
            system "clear"
            help
        else response == 'help'
            system "clear"
            help
        end
        puts "You have to either enter 'save' or 'help'!".green
        response = gets.chomp.to_s
    end

    def randomize(type)
        if type == "!"
            words = ["Fantastic!", "Outstanding!", "Incredible!", "Great!", "Very nice...", "Exceptional."]
            words[rand(words.length-1)]
        end
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