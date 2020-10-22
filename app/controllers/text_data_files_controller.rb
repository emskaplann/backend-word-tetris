require 'csv'
require 'set'
require 'date'

class TextDataFilesController < ApplicationController
    def create
        id_header = params[:id]
        name_header = params[:name]
        timestamp_header = params[:timestamp]
        available_headers = params[:table_headers].split(',')
        file = params[:file]

        # byebug

        csv_table = CSV.parse(File.read(file), headers: true)
        columns_to_delete = Set.new(csv_table.headers) ^ available_headers # O(n) time complexity

        columns_to_delete.each do |col| # deleting the columns we don't want
            csv_table.delete(col)
        end

        # Now I need to check if ID's are unique and if I can convert all the Timestamps
        # I need to get input for what to replace with non-convertible or null values for Timestamps

        # hash map to lookup iterated id's / there is another way to solve this but it's not efficient in terms of time complexity
        id_map = {}

        # Lists to send back if there is errors in the dataset to inform the user
        duplicate_id_list = []
        non_convertible_timestamp_id_list = []

        csv_table.each do |row|
            # Processing ID Column
            if(id_map[row[id_header]])
                duplicate_id_list.push(row[id_header])
                return false
            end
            id_map[row[id_header]] = true
            # End of processing ID Column

            # Processing Timestamp Column
            begin
                Date.parse(row[timestamp_header])
            rescue ArgumentError
                non_convertible_timestamp_id_list.push(row[id_header])
            rescue TypeError
                non_convertible_timestamp_id_list.push(row[id_header])
            end
            # End of processing Timestamp Column
        end

        if(duplicate_id_list.length > 0 || non_convertible_timestamp_id_list.length > 0) 
            # return error to the client and don't upload it.
            render json: {error: true}
        else
            # upload the file to the db and return success code to the client
            render json: {success: true}
        end
    end
end


# request body from the client
#   {
#     file: this.state.selectedFile,
#     tableHeaders: ["header_1", "header_2", "header_3", "header_4"]
#     assigned: {
#       id: "header_1",
#       ...
#     } 
#   }

# Headers: ["id", "country_code", "region_name", "company_name", "description", "last_funding_on", "total_funding_usd"]