class ApplicationController < ActionController::API
    def is_date?(date_str) # I validate timestamps with this function
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
        ['%m%d%Y',"%d%m%Y",'%m%d%y',"%d%m%y",'%D%M%Y','%M%D%Y','%D%M%y','%M%D%y'].each do |f|
        begin
            return true if Date.strptime(temp, f)
            rescue
                #do nothing
            end
        end
        return false
    end

    def is_datetime?(datetime_str) # I also validate timestamps with this function if they're not date
        begin
            splitted_str = datetime_str.split(/\W+/)
            for i in 0..splitted_str.length - 1
              if(splitted_str[i].length < 2)
                splitted_str[i] = "0#{splitted_str[i]}"
              end
            end
        rescue
            return false
        end
        temp = splitted_str.join()
        puts(temp)
        ['%m%d%Y%H%M','%d%m%Y%H%M','%m%d%y%H%M','%d%m%y%H%M','%M%D%Y%H%M','%D%M%Y%H%M','%D%M%y%H%M','%M%D%y%H%M'].each do |f|
        begin
            return true if DateTime.strptime(temp, f)
            rescue
                #do nothing
            end
        end
        return false
    end
end
