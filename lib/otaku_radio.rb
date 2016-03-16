require "otaku_radio/version"

require "json"
require "net/http"

module OtakuRadio
    class Onsen
        def initialize
            @base_url = 'http://www.onsen.ag/'
            @showMovie_endpoint = 'api/shownMovie/shownMovie.json'
            @getMovieInfo_endpoint = 'data/api/getMovieInfo/'
        end

        def program_list
            uri = URI.parse(@base_url + @showMovie_endpoint)
            json = Net::HTTP.get uri
            ret = JSON.parse(json)
            return ret
        end

        def get_program_info program
            uri = URI.parse(@base_url + @getMovieInfo_endpoint + program)
            json = Net::HTTP.get uri
            ret = JSON.parse(json.slice(9..json.length-4))
            return ret
        end
    end
end
