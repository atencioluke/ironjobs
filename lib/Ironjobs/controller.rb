class Ironjobs::Controller

    def call 
        self.welcome
    end

    def welcome
        system "clear"
        puts "Welcome to IronJobs!".light_blue
        puts "--------------------"
        puts "This application will allow you to search through a vast and current database of job openings across the United States!"
        puts "But, before we get started... introduce yourself!"
        puts "--------------------"
        self.initiate
    end

    def help
        puts "Below are a list of commands you can use!"
        puts "Enter 'Profile' to view or alter your profile."
        puts "Enter 'List' to view your list of saved jobs."
        puts "Enter 'Search' to search for the perfect job for you."
    end
    
    def initiate
        puts "What is your name?"
        name = gets.chomp.green
        puts "Okay, #{name}. What is your dream job title?"
        title = gets.chomp.to_s
        puts "#{randomize("!")} What city do you want to work in?"
        location = gets.chomp.to_s
        puts "Finally, what's your favorite programming language?"
        language = gets.chomp.to_s
        system "clear"
        puts "#{randomize("!")} Let's find you that #{title} job you are dying to get."
        new_user(name, title, location, language)
        puts "Do you want us to look for the perfect jobs based off your profile? Yes or no?"
        if gets.chomp.to_s.upcase == "yes".upcase
            system "clear"
            prompt = TTY::Prompt.new
            input = prompt.select("Select job using arrow keys and press enter!", Ironjobs::Jobs.search_by_profile)
            expand(input)
        else
            self.search
        end
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
        schedule = gets.chomp.to_s
        Ironjobs::Jobs.fetch(language,location,schedule)
        expand
    end

    def expand(input)
        puts "If you want to learn more about a position, enter it's number!"
        Ironjobs::Jobs.job_expand(input.split('').first.to_i)
        save
    end

    def save
        puts "If you want to save this job to your collection, enter 'save'. Otherwise, enter 'help'.".green
        puts "<-------------------------------------------------------------------------------------->".red
        response = gets.chomp.to_s
        if response == 'save'
            Ironjobs::User.user.save(Ironjobs::Jobs.job)
            system "clear"
        elsif response == 'help'
            system "clear"
            help
        elsif
            puts "You have to either enter 'save' or 'help'!".green
            response = gets.chomp.to_s
        end
    end

    def randomize(type)
        if type == "!"
            words = ["Fantastic!", "Outstanding!", "Incredible!", "Great!", "Very nice...", "Exceptional."]
            words[rand(words.length-1)]
        end
    end

end