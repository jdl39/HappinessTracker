# TODO: update and delete look copy-pasted.

class ActivitiesController < ApplicationController
    before_action :setup_goals, only: [:track_new_measurement, :get_activity_data]

    def create_activity
        # Parse json
        # json = JSON.parse(params[:json])
        p "PARAMS", params
        # Create return hash
        to_return = {}

        # Create activity
    	activity = Activity.new
    	activity.user = current_user

        # Normalize activity name; for now, let's just downcase everything
        if !params[:activity_name] 
            return
        end
        activity_name = params[:activity_name].split.map(&:downcase).join(' ')

        p "activity name", activity_name
        # Find activity type.
        activity_type = ActivityType.find_by(name: activity_name)
        p "activity type", activity_type
        activity_type = create_activity_type(activity_name) if activity_type.nil?

        # Save the activity.
    	activity.activity_type = activity_type
    	if activity.save
            p "Save successful!"
            activity.activity_type.num_users = activity.activity_type.num_users + 1 # TODO: Could this cause race conditions?
    		# Now, apply the measurement types.
            measurements = [params[:measure1], params[:measure2]]
            for measurement_name in measurements do
                if(measurement_name)
                    measurement_name = measurement_name.split.map(&:downcase).join(' ')
                    measurement = MeasurementType.find_by(name: measurement_name)
                    if measurement.nil?
                        measurement = MeasurementType.new
                        measurement.name = measurement_name
                        measurement.is_quantifiable = true # TODO: Add the ability to make boolean measurement types.
                        if not measurement.save
                            # Measurement save error.
                            to_return["hapapp_error"] = "Could not save new measurement type " + measurement_name + "."
                            if to_return["errors"].nil?
                                to_return["errors"] = []
                            end
                            to_return["errors"].concat(measurement.errors.full_messages)
                            next
                        end
                    end
                end
                activity.measurement_types << measurement
            end
            activity.save
    	else
    		# Activity couldn't save
            p "Could not save activity"
            to_return["hapapp_error"] = "Could not save activity."
            to_return["errors"] = activity.errors.full_messages
            render json: to_return
            return
    	end
        to_return["measurement_types"] = activity.measurement_types.pluck(:id,:name,:is_quantifiable)
        # TODO: Build the json to return.
        render json: to_return
    end

    def create_activity_type(activity_name)
        activity_type = ActivityType.new
        activity_type.name = activity_name
        lemmatizer = Lemmatizer.new
        activity_words = activity_name.split
        activity_words |= activity_words.map{|word| lemmatizer.lemma(word)}
        # debugger
        activity_words.split.each do |word|
            word = ActivityWord.new
            activity_type = activity_type
        end
        activity_type.num_users = 0
        activity_type.save
        return activity_type
    end

    # TODO: Allow for measurement notes to be submitted.
    def track_new_measurement
        # Parse json
        # json = JSON.parse(params[:json])

        # Hash to return
        to_return = {}

        # Check to ensure that such an activity type exists.
        activity_name = params[:activity_name].downcase
        activity_type = ActivityType.find_by(name: activity_name)
        if activity_type.nil?
            to_return["hapapp_error"] = "There is no activity type with that name."
            render json: to_return
            return
        end

        # Check to ensure that the user is associated with that activity.
        activity = Activity.where("activity_type_id = ? AND user_id = ?", activity_type.id, current_user.id).take
        if activity.nil?
            to_return["hapapp_error"] = "The current user is not associated with that activity type."
            render json: to_return
            return
        end

        to_return["new_measurements"] = []
        measurements = [[params[:measure1], params[:value1]], [params[:measure2], params[:value2]]]
        for measurement_array in measurements do
            measurement_name = measurement_array[0]
            measurement_value = measurement_array[1].to_f
            p "LOOK AT ME", measurement_value
            if measurement_name
                measurement_name = measurement_name.downcase
                measurement_type = MeasurementType.find_by(name: measurement_name)
                if measurement_type.nil?
                    to_return["hapapp_error"] = "The measurement " + measurement_name + " doesn't exist."
                    next
                end
                to_return["new_measurements"] << activity.user.log_new_measurement(activity, measurement_type, measurement_value).to_javascript_measurement
            end
        end

        # TODO: Do we need more to return in the json?
        render json: to_return
    end

    # TODO: Consider caching results in db for quick processing?
    def recommendations
        render json: {:recommendation_array => current_user.activity_recommendations}
    end

    $max_result_size = 6
    $recent_measurements_size = 30

    # Intelligent search for activities
    # Must include:
    # BOOLEAN: query_activity_exists (do we need to present the "add new" option)
    # BOOLEAN: user_does_activity
    # LIST<ACTIVITY>: search_results (can be empty)
    # LIST<FRIEND>: friends (who do the topmost activity)
    # MEASUREMENT_TYPE: measurement_type (for topmost activity)
    # => Should have all data needed to render (past measurements, measurement-types, etc.)
    # => Should also include friends who do activity
    #
    # for now, I'm assuming everything is lower case
    def search
        search_str = params['str']

        # (1) do prefix search on activity db (not activity words) for exact matching
        search_results = []
        type = ActivityType.where(name: search_str).pluck(:id, :name)
        query_activity_exists = !type.empty?
        search_results |= type.to_a unless type.nil?
        types = ActivityType.where('name LIKE ?', search_str + '%').order('num_users DESC').pluck(:id, :name)
        search_results |= types.to_a

        puts "SEARCH RESULTS 1"
        p search_results.size
        p search_results

        spellCheckedWords = nil
        spelling_sugs = []
        if(search_str.length > 3)
            spellCheckedWords = Spellchecker.check(search_str)
            spelling_sugs = spellCheckedWords.map{|wordCheck| wordCheck[:correct] ? nil : wordCheck[:suggestions].first}
        end

        render json:  {
            query_activity_exists: query_activity_exists,
            search_results: search_results,
            spelling_sugs: spelling_sugs
        }
    end

    def get_activity_data
        friends = []
        measurement_types = nil
        recent_measurements = []

        friends = current_user.friends
        #puts "yo"

        top_result_id = ActivityType.find_by(name: params[:str]).id
        top_activities = Activity.where(activity_type_id: top_result_id)
        #top_activities = Activity.where(activity_type_id: params[:top_result_id])

        if top_activities.empty?
            render json: {
                user_does_activity: false,
                friends: [],
                measurement_types: [],
                recent_measurements: [],
                recent_measurement_notes: [],
                activity_id: top_result_id
            }
            return
        end

        user_activity = top_activities.select{|activity| activity.user == current_user}.first
        user_does_activity = !user_activity.nil?
        friend_activities = top_activities.to_a.select{|activity| friends.include? activity.user}
        friends = []
        friends = friend_activities.sort!{|activity| activity.num_measured}.reverse!.map(&:user) unless friend_activities.empty?

        if user_does_activity
            # get user's personal data for the activity
            measurement_types = user_activity.measurement_types.pluck(:id,:name,:is_quantifiable)
            # recent_measurements = Measurement.where(activity: user_activity).order('created_at DESC').first $recent_measurements_size
            recent_measurements = Measurement.where(activity: user_activity).order('created_at ASC')
            recent_measurement_notes = recent_measurements.map(&:measurement_note)
        else
            # get the most common measurement for the topmost activity
            measurement_types = top_activities.group_by{|activity| activity.measurement_types.pluck(:id,:name,:is_quantifiable)}.to_a.sort{|measurement, activities| activities.size}.last.first
        end

        recent_measurement_hashs = []
        recent_measurements.each do |measurement|
            recent_measurement_hashs << measurement.to_javascript_measurement
        end
        p recent_measurement_hashs
        render json:  {
            user_does_activity: user_does_activity,
            friends: friends,
            measurement_types: measurement_types,
            recent_measurements: recent_measurement_hashs,
            recent_measurement_notes: recent_measurement_notes,
            activity_id: top_result_id
        }
    end

    def search_more
        search_str = params['str']
        search_results = []
        lex = WordNet::Lexicon.new

        # (2) get activities by how many words they have in common with the query, spelling fixed or not
            spellCheckedWords = Spellchecker.check(search_str)
            lemmatizer = Lemmatizer.new
            spellCheckedWords.each do |wordCheck|
                if wordCheck[:correct]
                    wordCheck[:lemma] = lemmatizer.lemma(wordCheck[:original])
                else
                    # prune spelling suggestions
                    nonCompounds =  wordCheck[:suggestions].select{|sug| !(sug =~ /^\w*$/).nil?}[0...1]
                    nonCompounds = wordCheck[:suggestions][0...1] if nonCompounds.empty?
                    # if we want more spelling suggestions, change both of the above [0...1] to [0...n]
                    wordCheck[:suggestions] = nonCompounds
                    puts "hey hey"
                    p nonCompounds
                end
            end
            
            # get actual words out
            searchWords = spellCheckedWords.map{|wordCheck| wordCheck[:correct] ? [wordCheck[:original], wordCheck[:lemma]].uniq : wordCheck[:suggestions].map{|sug| lemmatizer.lemma(sug)}}
            search_results |= getTypesForWords(searchWords)

            puts "SEARCH RESULTS 2"
            p search_results.size
            p search_results

        # (3) get activities by how many words they have in common with synonyms of correctly spelled words
        if search_results.size < $max_result_size
            spellCheckedWords.each do |wordCheck|
                wordCheck[:synsets] = wordCheck[:correct] ? lex.lookup_synsets(wordCheck[:lemma]) : []
            end

            searchWords = spellCheckedWords.map{|wordCheck| wordCheck[:synsets].reduce([]){|sum, n| sum | n.words.map(&:lemma)}}.flatten
            search_results |= getTypesForWords(searchWords)

            puts "SEARCH RESULTS 3"
            p search_results.size
            p search_results
        end

        # FOR SPEED UP, NOT DOING FINAL TIER FOR NOW

        # (4) same as (3) except for cousins, where I'm defining cousins as hyponyms of hypernyms
        if false && search_results.size < $max_result_size
            spellCheckedWords.each do |wordCheck|
                wordCheck[:cousins] = wordCheck[:correct] ? wordCheck[:synsets].map{|synset| synset.hypernyms.map{|x| x.hyponyms}}.flatten : []
                # could also do the same for words spelled incorrectly, but passing for now
            end
            searchWords = spellCheckedWords.map{|wordCheck| wordCheck[:cousins].reduce([]){|sum, n| sum | n.words.map(&:lemma)}}.flatten
            search_results |= getTypesForWords(searchWords)
            
            puts "SEARCH RESULTS 4"
            p search_results.size
            p search_results
        end

        render json:  {
            search_results: search_results
        }
    end

    # Takes in an activity_type id and a user id and returns all data associated with them.
    # TODO: Consider how privacy concerns may affect how this should be handled.
    def data_for_user
    	# Return data_for_user_helper
    end

    def delete_me
        session["comments"] = []
        session["upvoted_comments"] = []
        session["responses"] = []
        session["upvoted_responses"] = []
    end

    # call repeatedly to get more comments
    # params; num_needed
    def getComments
        new_comments = current_user.readable_comments.limit(params[:num_needed].to_i).where(activity_type_id: params[:activity_type_id]).where.not(id: session[:comments]).order('created_at DESC').select('comments.id as id, content, created_at, signature')
        if session[:comments].nil?
            session[:comments] = new_comments.map(&:id)
        else
            session[:comments].concat new_comments.map(&:id)
        end
        upvoted_comments = new_comments.select{|comment| comment.up_voters.include? current_user}
        # for ith comment in comments, true if upvoted, false if not
        session[:upvoted_comments] = Comment.where(id: session[:comments]).select{|comment| upvoted_comments.include? comment}.map(&:id)
        render json:  {
            new_comments: new_comments,
            upvoted_comments: upvoted_comments
        }
    end

    # params: comment_id, num_needed
    def getResponses
        new_responses = current_user.readable_responses.limit(params[:num_needed].to_i).where(comment_id: params[:comment_id]).where.not(id: session[:responses]).order('created_at DESC').select('responses.id as id, content, created_at, signature')
        p new_responses
        if session[:responses].nil?
            session[:responses] = new_responses.map(&:id)
        else
            session[:responses].concat new_responses.map(&:id)
        end
        upvoted_responses = new_responses.select{|response| response.up_voters.include? current_user}
        # for ith comment in comments, true if upvoted, false if not
        session[:upvoted_responses] = Response.where(id: session[:responses]).select{|response| upvoted_responses.include? response}.map(&:id)
        render json:  {
            new_responses: new_responses,
            upvoted_responses: upvoted_responses
        }
    end

    $vote_threshold = -3
    $spread_amount = 5
    $history_size = 25

    # params: activity, content, signature
    def new_comment
        comment = Comment.create(author: current_user, activity_type_id: params[:activity_type_id], content: params[:content])
        comment.signature = params[:anonymous] ? "anonymous" : current_user.username
        new_readers = User.limit($spread_amount).where.not(id: current_user).order("RANDOM()")
        new_readers |= current_user.friends
        comment.readers.concat new_readers
        comment.save
        new_readers.each do |reader|
            if reader.readable_comments.size > $history_size
                reader.readable_comments.sort{|a,b| a.created_at <=> b.created_at}.first.remove
            end
            reader.save
        end
        # TODO: flash feedback
        render nothing: true
    end

    # params: comment_index, content, signature, isPublic
    def new_response
        comment = Comment.find(params[:comment_id].to_i)
        sender_sig = params[:anonymous] == "true" ? "anonymous" : current_user.username
        # create a message to author of comment from user
        message = Message.create(sender: current_user, receiver: comment.author, quote: comment.content, content: params[:content], receiver_sig: comment.signature, sender_sig: sender_sig)
        if params[:is_public] == "true"
            response = Response.create(author: current_user, comment: comment, content: params[:content])
            response.signature = signature
            new_readers = User.limit($spread_amount).where.not(id: current_user).order("RANDOM()")
            new_readers |= current_user.users
            response.readers.concat new_readers
            response.save
            new_readers.each do |reader|
                if reader.readable_responses.size > $history_size
                    reader.readable_responses.sort{|a,b| a.created_at <=> b.created_at}.first.remove
                end
                reader.save
            end
        end 
        render nothing: true
    end

    def new_r_response
        comment = Comment.find(params[:comment_id])
        sender_sig = params[:anonymous] ? "anonymous" : current_user.username
        message = Message.create(sender: current_user, receiver: comment.author, quote: comment.content, content: params[:content], receiver_sig: comment.signature, receiver_sig: sender_sig)
        render nothing: true
    end

    def up_comment
        puts "up comment!"
        comment = Comment.find(params[:comment_id])
        # do nothing if user already voted
        unless comment.up_voters.include? current_user
            puts "not already up voted"
            comment.up_voters << current_user
            comment.votes = comment.votes.to_i + 1
            avoid_users = comment.down_voters | comment.readers | [current_user.id]
            new_readers = User.limit($spread_amount).where.not(id: avoid_users).order("RANDOM()")
            comment.readers.concat new_readers
            comment.save
            new_readers.each do |reader|
                if reader.readable_comments.size > $history_size
                    reader.readable_comments.sort{|a,b| a.created_at <=> b.created_at}.first.remove
                end
                reader.save
            end
        end
        puts "finished"
        render nothing: true
    end

    def down_comment
        puts "down comment!"
        comment = Comment.find(params[:comment_id])
        # do nothing if user already voted
        unless comment.down_voters.include? current_user
            puts "not already down voted"
            comment.down_voters << current_user
            comment.votes = comment.votes.to_i - 1
            comment.readers.delete(current_user)
            comment.readers.delete_all if comment.votes < $vote_threshold
            comment.up_voters.delete(current_user)
            comment.save
        end
        puts "finished"
        render nothing: true
    end

    def up_response
        puts "up resonse! " + params[:respond_id]
        response = Response.find(params[:response_id])
        # do nothing if user already voted
        unless response.up_voters.include? current_user
            puts "not already up voted"
            response.votes = response.votes.to_i + 1
            avoid_users = response.down_voters | response.readers | [response_user.id]
            new_readers = User.limit($spread_amount).where.not(id: avoid_users).order("RANDOM()")
            response.readers.concat new_readers
            response.save
            new_readers.each do |reader|
                if reader.readable_responses.size > $history_size
                    reader.readable_responses.sort{|a,b| a.created_at <=> b.created_at}.first.remove
                end
                reader.save
            end
        end
        puts "finished"
        render nothing: true
    end

    # params: response_id
    def down_response
        puts "down response! " + params[:response_id]
        response = Response.find(params[:response_id])
        # do nothing if user already voted
        unless response.down_voters.include? current_user
            puts "not already down voted"
            response.votes = response.votes.to_i - 1
            response.up_voters.delete(current_user)
            response.readers.delete(current_user)
            response.readers.delete_all if response.votes < $vote_threshold
            response.save
        end
        puts "finished"
        render nothing: true
    end

	private

    def getTypesForWords(searchWords)
        puts "searchwords"
        p searchWords
        types = searchWords.map{|wordGroup|
            ActivityWord.where(word: searchWords).map(&:activity_type).uniq
        }
        types = types.flatten.group_by{|type| type}.to_a.map{|type, group| [type, group.size]}
        types.sort! do |a, b|
            comp = a[1] <=> b[1]
            comp == 0 ? a[0].num_users <=> b[0].num_users : comp
        end
        return types.map{|type, size| [type.id, type.name]}
    end

    def num_users
        @num_users ||= User.all.size
        return @num_users
    end

    # Use callbacks to share common setup or constraints between actions.	   
    def set_activity
       @activity = Activity.find(params[:id])
    end

    # Helper for search and data_for_user
    def data_for_user_helper(user_id, activity_type_id)
    	# TODO: Implement.
    end

    def setup_goals
        Goal.setup_goals_for(current_user)
    end
end
