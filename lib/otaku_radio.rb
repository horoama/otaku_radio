require "otaku_radio/version"

require "json"
require "net/http"
require "uri"

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

        def download(program , path)
            info = self.get_program_info program
            if info.include?("error")
                return
            end
            moviepath = info["moviePath"]["pc"]
            unless moviepath.empty?
                res = Net::HTTP.get URI.parse(moviepath)
                File.binwrite(path, res)
            end
        end
    end
end
