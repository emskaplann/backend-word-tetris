class ApplicationController < ActionController::API
    def is_date?(date_str)
        begin
            splitted_str = date_str.split(/\W+/)
            for i in 0..splitted_str.length - 1
              if(splitted_str[i].length < 2)
                splitted_str[i] = "0#{splitted_str[i]}"
              end
            end
        rescue
            return false
        end
        temp = splitted_str.join()
        ['%m%d%Y','%m%d%y','%M%D%Y','%M%D%y'].each do |f|
        begin
            return true if Date.strptime(temp, f)
            rescue
                #do nothing
            end
        end
        return false
    end
end
