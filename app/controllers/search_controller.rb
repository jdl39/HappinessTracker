class SearchController < ApplicationController
    def index
        session["comments"] = []
        session["upvoted_comments"] = []
        session["responses"] = []
        session["upvoted_responses"] = []
        @startingStr = params[:str]
    end
end
