# -*- encoding : utf-8 -*-
require 'find'

module ApiV1
  class SongsController < ApiController

    def index
      songs_as_json = nil

      if params[:refresh]
        Rails.logger.info 'Forced song list refresh'
        songs_as_json = refresh_and_get_all
      else
        songs_as_json = Song.all_as_json
        songs_as_json = refresh_and_get_all if songs_as_json == '[]'
      end

      render :text => songs_as_json
    end

    def play
      filepath = Song.MUSIC_PATH + params[:file]

      response.content_type = Mime::Type.lookup_by_extension("mp3")

      render :text => File.open(filepath, 'rb') { |f| f.read }
      #send_file filepath, :type => 'audio/mpeg'
    end

    private

      def refresh_and_get_all
        Song.refresh
        Song.all_as_json
      end

  end
end
