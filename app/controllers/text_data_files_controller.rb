require 'csv'
require 'set'
require 'date'

class TextDataFilesController < ApplicationController
    def index # rendering all created objects to the user, url is ..../text-data-files, GET Request
        @all_files = TextDataFile.all
        render json: @all_files, :status => :ok
    end
    
    def create # validating, creating and importing the new file to the internal system, url is ..../text-data-files, POST Request
        # getting parameters from the request
        id_header = params[:id] 
        name_header = params[:name]
        timestamp_header = params[:timestamp]
        available_headers = params[:table_headers].split(',')
        file = params[:file]

        # parse according to the file type, checking file type 
        if(params[:as_string] === "true") 
            csv_table = CSV.parse(file, headers: true)
        else
            if(file.content_type == "text/tab-separated-values")
                csv_table = CSV.parse(File.read(file), :headers => true, :col_sep => "\t")
            else
                csv_table = CSV.parse(File.read(file), :headers => true)
            end
        end

        # mapping columns we need to delete
        columns_to_delete = Set.new(csv_table.headers) ^ available_headers # O(n) time complexity

        columns_to_delete.each do |col| # deleting the columns user don't want
            csv_table.delete(col)
        end

        # Now I need to check if ID's are unique and if I can convert all the Timestamps
        # I need to get input for what to replace with non-convertible or null values for Timestamps

        # hash map to lookup iterated id's / there is another way to solve this but it's not efficient in terms of time complexity
        id_map = {}

        # Lists to send back if there is errors in the dataset to inform the user
        duplicate_id_list = []
        non_convertible_timestamp_id_list = []

        # Delete Non Applicable Columns
        csv_table.delete_if do |row|
            if(row[id_header] == "NA" || row[id_header] == "Na" || row[id_header] == "na" || row[id_header] == "")
                true
            end
        end
        # End of deleting

        # processing each column
        csv_table.each do |row|
            # Processing ID Column
            if(id_map[row[id_header]])
                duplicate_id_list.push(row[id_header])
            else
                id_map[row[id_header]] = true
            end
            # End of processing ID Column

            # Processing Timestamp Column
            if(!is_date?(row[timestamp_header]) && !is_datetime?(row[timestamp_header])) 
                non_convertible_timestamp_id_list.push(row[id_header]) 
            end
            # End of processing Timestamp Column
        end

        if(duplicate_id_list.length > 0 || non_convertible_timestamp_id_list.length > 0) 
            # return error to the client and don't import it into the system.
            render json: {error: true, success: false, duplicate_id_list_length: duplicate_id_list.length, non_convertible_timestamp_id_list_length: non_convertible_timestamp_id_list.length, duplicate_id_list: duplicate_id_list, non_convertible_timestamp_id_list: non_convertible_timestamp_id_list}, :status => :ok
        else
            # upload the file to the db and return success code to the client

            # write the file
            if(params[:as_string])
                file_location = "./temp-file.csv"
            else
                file_location = "./#{params[:file].original_filename}"
            end
            File.write(file_location, csv_table)

            # upload to the database
            cloudinary_response = Cloudinary::Uploader.upload(file_location, :resource_type => :raw)
            file_url = cloudinary_response["url"]
            # example response => {"asset_id"=>"12e15428161cf93a8d1688285b2dea63", "public_id"=>"gfxtbfeypd0hdvgrofaw.csv", "version"=>1603398664, "version_id"=>"455c519ac2c0af576b99a6da6d699e0c", "signature"=>"69e12c780e1a2b0c34923e9cce956892994c58fa", "resource_type"=>"raw", "created_at"=>"2020-10-22T20:31:04Z", "tags"=>[], "bytes"=>58647, "type"=>"upload", "etag"=>"9596578e31387b53f4e25dcf53b7bb72", "placeholder"=>false, "url"=>"http://res.cloudinary.com/dsvgmn8lx/raw/upload/v1603398664/gfxtbfeypd0hdvgrofaw.csv", "secure_url"=>"https://res.cloudinary.com/dsvgmn8lx/raw/upload/v1603398664/gfxtbfeypd0hdvgrofaw.csv", "original_filename"=>"company_data"}

            # delete it on local
            File.delete(file_location)

            # create the object and return necessary values to the front end
            @new_file = TextDataFile.create(:id_column => id_header, :name_column => name_header, :timestamp_column => timestamp_header, :link => file_url)
            render json: @new_file, :serializer => TextDataFileSerializer, :status => :ok
        end
    end
end


# example request body from the client
#   {
#     file: this.state.selectedFile,
#     tableHeaders: ["header_1", "header_2", "header_3", "header_4"]
#     assigned: {
#       id: "header_1",
#       ...
#     } 
#   }

# Headers: ["id", "country_code", "region_name", "company_name", "description", "last_funding_on", "total_funding_usd"]