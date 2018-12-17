class Ironjobs::Api
    def parse
        @@list = JSON.parse(data)
        @@list.each do |job|
            puts job
        end
    end
end