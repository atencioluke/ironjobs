class Ironjobs::Controller
    def call 
        self.welcome
    end

    def welcome
        #testing
        system "clear"
        puts "Welcome to IronJobs!"
        puts "--------------------"
        puts "This application will allow you to search through a vast and current database of job openings across the United States!"
        puts "But, before we get started... introduce yourself!"
        puts "--------------------"
        self.initiate
    end
    
      def initiate
        puts "What is your name?"
        name = gets.chomp
        puts "What is the job title you wish to have?"
        title = gets.chomp.to_s
        puts "Where are you job searching?"
        location = gets.chomp.to_s
        puts "What's your favorite programming language?"
        language = gets.chomp.to_s
        system "clear"
        puts "Hello #{name}! Let's find you that #{title} job you are dying to get."
        new_user(name, title, location, language)
        puts "Do you want us to look for the perfect jobs based off your profile? Yes or no?"
        if gets.chomp.to_s.upcase == "yes".upcase
            Ironjobs::Jobs.search_by_profile
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

      def expand
        puts "If you want to learn more about a position, enter it's number!"

      end

end