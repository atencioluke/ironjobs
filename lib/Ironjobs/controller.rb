class Ironjobs::Controller

    attr_accessor :active_user

    #The first method called when the application runs. This method is called in the bin/ironjobs file.
    def call
        self.welcome
    end

    #Application initializes with an active user, so we can keep track of the user instance for profile fetching and job saving.
    #This also allows for us to add functionality to add more users and keep track of who's using the application.
    #Additionally, we store the "TTY Prompt" gem line of code in an instance variable to keep up with DRY coding.
    def initialize
        @active_user = nil
        @prompt = TTY::Prompt.new
    end

    #The welcome method is the first interaction the user has with the application. It welcomes them and calls on the initiate method.
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

    #The initiate method will ask for the user's information to create an instance of the "User" class for storing job and user related info.
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
        # new_user("Matthew", "Software Engineer", "Boston", "Python")
        system "clear"
        help
    end

    #This method actually creates the instance for the new user and saves that user as the active user until the active user changes again.
    def new_user(name, title, location, language)
        @active_user = Ironjobs::User.new(name, title, location, language)
    end

    #The help method is the main navigation for the application. The user can..
    # 1. See their own profile
    # 2. View their saved jobs
    # 3. Search for jobs based off of keywords.
    # 4. Search for jobs based off their profile attributes.
    # 5. View a list of recently searched jobs.
    # 6. Exit the application.
    def help
        list = ["View or alter your profile",
            "View your list of saved jobs",
            "Search for a specific job",
            "Search for a job based off of your profile",
            "View your history of job searches",
            "exit"]
        input = @prompt.select("Select command using arrow keys and press enter!".light_blue, list)
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

    #This method simply displays the attributes set by the user.
    def user_profile
        @active_user.user_profile
        input = @prompt.select("You can go back to the help menu or exit the proram.", ["Help menu", "Exit program"])
        case input
        when "Help menu"
            self.help
        when "exit program"
            self.exit
        end
    end
   
    #This method displays the jobs saved by the active user to their profile and allows the user to search through those jobs.
    def user_joblist
        if @active_user.list.length == 0
            system "clear"
            puts "
            You have not saved any jobs to your profile yet!
            
            ".light_blue
            self.help
        else
            job = @prompt.select("Select job using arrow keys and press enter!", @active_user.list.map {|i| i.title})
            self.job_expand(job)
        end
    end

    #The search method will prompt the active user to input keywords and then fetch by that "job". It will call on a method in the 
    # jobs class, which calls on the fetch method in the API class.
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
        list(Ironjobs::Jobs.fetch_by_job(language,location,full_time))
    end

    #This method lists the jobs returned from search methods.
    def list(fetch)
        binding.pry
        input = @prompt.select("Select job using arrow keys and press enter!", fetch)
        job_expand(input)
    end

    #This method will provide more in-depth details about a selected job from the list after a search was done. It checks to make sure 
    # that the selection is actually a part of the list.
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

    #This method will save the selected job to the active user's profile (instance).
    def save(job)
        puts "<-------------------------------------------------------------------------------------->".red
        response = @prompt.select("Save to store this job on your profile OR help to go back to the main menu.".light_blue, ['Save','Help'])
        if response == 'Save'
            @active_user.save(job)
            system "clear"
            self.help
        else response == 'Help'
            system "clear"
            self.help
        end
    end

    #The history method either provides a list of the most recent searches and allows the active user to select from them, or
    # it states that no jobs have been searched for recently.
    def history
        if Ironjobs::Jobs.all.length == 0
            system "clear"
            puts "
            You have not searched for any jobs recently.
            
            ".light_blue
            self.help
        else
            system "clear"
            input = @prompt.select("Select command using arrow keys and press enter!".light_blue, Ironjobs::Jobs.all.map {|i| i.title})
            job_expand(input)
        end
    end

    #This method is just added 'personality' which randomizes responses in certain parts of the application.
    def randomize(type)
        if type == "!"
            words = ["Fantastic!", "Outstanding!", "Incredible!", "Great!", "Very nice...", "Exceptional."]
            words[rand(words.length-1)]
        end
    end

    #The exit method will quit out of the application.
    def exit
        system "clear"
        puts "Singing off. Thank you for using Ironjobs!".green
    end
end