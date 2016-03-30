require "otaku_radio/version"

require "json"
require "net/http"
require "uri"

module OtakuRadio

    class Onsen
        attr_accessor :list
        def initialize
            @base_url = 'http://www.onsen.ag/'
            @showMovie_endpoint = 'api/shownMovie/shownMovie.json'
            @getMovieInfo_endpoint = 'data/api/getMovieInfo/'
            @list = {}
        end

        def program_list
            uri = URI.parse(@base_url + @showMovie_endpoint)
            json = Net::HTTP.get uri
            ret = JSON.parse(json)
            return ret["result"]
        end

        def get_program_info program
            uri = URI.parse(@base_url + @getMovieInfo_endpoint + program)
            json = Net::HTTP.get uri
            ret = JSON.parse(json.slice(9..json.length-4))
            return ret
        end

        def download(program , path)
            info = self.get_program_info program
            return if info.include?("error")
            moviepath = info["moviePath"]["pc"]
            unless moviepath.empty?
                res = Net::HTTP.get URI.parse(moviepath)
                File.binwrite(path, res)
            end
        end

        def updated? program
            if @list.empty?
                @list = self.get_program_info program
                return true
            else
                latest_list = self.get_program_info program
                if latest_list["count"] > @list["count"]
                    @list = latest_list
                    return true
                else
                    return false
                end
            end
        end
    end
end
