# TODO: update and delete look copy-pasted.

class ActivitiesController < ApplicationController
    def create_activity
        # Parse json
        json = JSON.parse(params[:json])

        # Create return hash
        to_return = {}

        # Create activity
    	activity = Activity.new
    	activity.user = current_user

        # Normalize activity name; for now, let's just downcase everything
        activity_name = json[:activity_name].split.map(&:downcase).join(' ')

        # Find activity type.
        activity_type = ActivityType.find_by(name: activity_name)
        create_activity_type(activity_name) if activity_type.nil?

        # Save the activity.
    	activity.activity_type = activity_type
    	if activity.save
            activity.activity_type.num_users = activity.activity_type.num_users + 1 # TODO: Could this cause race conditions?
    		# Now, apply the measurement types.
            for measurement_name in json[:measurements] do
                measurement_name = measurement_name.split.map(&:capitalize).join(' ')
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
                activity.measurement_types << measurement
            end
    	else
    		# Activity couldn't save
            to_return["hapapp_error"] = "Could not save activity."
            to_return["errors"] = activity.errors.full_messages
            render json: to_return
            return
    	end

        # TODO: Build the json to return.
        render json: to_return
    end

    def create_activity_type(activity_name)
        activity_type = ActivityType.new
        activity_type.name = activity_name
        lemmatizer = Lemmatizer.new
        activity_words = activity_name.split
        activity_words |= activity_words.map{|word| lemmatizer.lemma(word)}
        activity_words.split.each do |word|
            activity_word.word = ActivityWord.new
            activity_word.activity_type = activity_type
        end
        activity_type.num_users = 0
        unless activity_type.save
            # Activity_type save error
            to_return["hapapp_error"] = "Could not save the activity type."
            to_return["errors"] = activity_type.errors.full_messages
            render json: to_return
            return
        end
    end

    # TODO: Allow for measurement notes to be submitted.
    def track_new_measurement
        # Parse json
        json = JSON.parse(params[:json])

        # Hash to return
        to_return = {}

        # Check to ensure that such an activity type exists.
        activity_name = json[:activity_name].split.map(&:capitalize).join(' ')
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

        for measurement_name in json[:measurements] do
            measurement_name = measurement_name.split.map(&:capitalize).join(' ')
            measurement_type = MeasurementType.find_by(name: measurement_name)
            if measurement_type.nil?
                to_return["hapapp_error"] = "The measurement " + measurement_name + " doesn't exist."
                next
            end
            measurement = Measurement.new
            measurement.measurement_type = measurement_type
            measurement.activity = activity
            measurement.value = json[:measurements][measurement_name]
            if not measurement.save
                to_return["hapapp_error"] = "Could not save all measurements."
                if to_return["errors"].nil?
                    to_return["errors"] = []
                end
                to_return["errors"].concat(measurement.errors.full_messages)
            end
        end

        # TODO: Do we need more to return in the json?
        render json: to_return
    end

    # TODO: Consider caching results in db for quick processing?
    def recommendations
        render json: {:recommendation_array => activity_recommendations}
    end

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
        max_result_size = 7
        recent_measurements_size = 30

        searchString = params[:str]

        # (1) do prefix search on activity db (not activity words) for exact matching
        search_results = []
        type = ActivityType.name_equals(searchString)
        query_activity_exists = !type.nil?
        search_results << type unless type.nil?
        #types = ActivityType.descend_by_num_users.name_begins_with(searchString)
        types = ActivityType.where('name LIKE ?%', searchString).order('num_users DESC')
        search_results.concat types

        lex = WordNet::Lexicon.new

        # (2) get activities by how many words they have in common with the query, spelling fixed or not, plus synonyms
        spellCheckedWords
        if search_results.size < max_result_size
            spellCheckedWords = Spellchecker.check(searchString)
            # lemmatize words
            lemmatizer = Lemmatizer.new
            spellCheckedWords.each do |wordCheck|
                if wordCheck[:correct]
                    # get lemma and synonyms 
                    wordCheck[:lemma] = lemmatizer.lemma(wordCheck[:original])
                    wordCheck[:synsets] = lex.lookup_synsets(wordCheck[:original]) | lex.lookup_synsets(wordCheck[:lemma])
                else
                    # prune spelling suggestions
                    nonCompounds =  wordCheck[:suggestions].select{|sug| !(sug =~ /^\w*$/).nil?}[0]#can change: [0...n]
                    nonCompounds = [wordCheck[:suggestions][0]] if nonCompounds.empty?
                    wordCheck[:suggestions] |= nonCompounds.map{|sug| lemmatizer.lemma(sug)}
                end
            end

            # get actual words out
            searchWords = spellCheckedWords.map{|wordCheck| wordCheck[:correct] ? wordCheck[:synsets].reduce([]){|sum, n| sum | n.words.map(&:lemma)} << wordCheck[:original] << wordCheck[:lemma] : wordCheck[:suggestions]}


            searc_results.concat getTypesForWords(searchWords)
        end

        # (3) same as (2) except for cousins, where I'm defining cousins as hyponyms of hypernyms
        if search_results.size < max_result_size
            spellCheckedWords.each do |wordCheck|
                if wordCheck[:correct]
                    # get cousins 
                    wordCheck[:cousins] = wordCheck[:synsets].map{|synset| synset.hypernyms.map{|x| x.hyponyms}}.flatten
                end
                # could also do the same for words spelled incorrectly, but passing for now
            end
            searchWords = spellCheckedWords.map{|wordCheck| wordCheck[:cousins].reduce([]){|sum, n| sum | n.words.map(&:lemma)}} 
            search_results.concat getTypesForWords(searchWords)
        end

        # that's all the search results!

        friends = []
        measurement_type = nil
        recent_measurements = []
        unless search_results.empty?
            # get the friends who do the topmost activity sorted by who does it the most
            top_type = search_results.first 
            friends = Friendship.where(first: current_user).map(&:second)
            top_activities = Activity.where(activity_type: top_type)
            user_activity = top_activities.select{|activity| activity.user = current_user}
            user_does_activity = !user_version.empty?
            friends = top_activites.select!{|activity| friends.include? activity.user}.sort!{|activity| activity.num_measured}.reverse.map(&:user)

            if user_does_activity
                # get user's personal data for the activity
                measurement_type = user_activity.measurement_type
                #recent_measurements = Measurement.descend_by_timestamp.activity_equals(user_activity).first recent_measurements_size
                recent_measurements = Measurement.where(activity: user_activity).order('created_at DESC') first recent_measurements_size
            else
                # get the most common measurement for the topmost activity
                measurement_type = top_activities.group_by{|activity| activity.measurement_type}.to_a.sort{|measurement, activities| activities.size}.last.first
            end
        end

        render json:  {
            query_activity_exists: query_activity_exists,
            user_does_activity: user_does_activity,
            search_results: search_results,
            friends: friends,
            measurement_type: measurement_type,
            recent_measurements: recent_measurements
        }
    end

    def getTypesForWords(searchWords)
        types = searchWords.map{|wordGroup|
            wordGroup.reduce([]){|sum, searchWord|
                sum | ActivityType.where(activity_word: searchWord)
            }
        }
        return types.flatten.group_by{|type| type}.to_a.map{|pair| [pair[0], pair[1].size]}.sort{|pair| pair[1], pair[0].num_users}.map{|pair| pair[0]}
# don't actually know if the ', pair[0].num_users' works
    end

    # Takes in an activity_type id and a user id and returns all data associated with them.
    # TODO: Consider how privacy concerns may affect how this should be handled.
    def data_for_user
    	# Return data_for_user_helper
    end


	private

        def activity_recommendations
            score_hash = {}
            for activity_type in ActivityType.all do
                prior = activity_type.activities.size * 1.0 / num_users
                score_hash[activity_type.name] = prior
            end

            for activity in current_user.activities do
                count_hash = Hash.new { |hash,key| hash[key] = 1 }
                this_activity_type = activity.activity_type
                for other_instance in this_activity_type.activities do
                    for activity_to_count in other_instance.user.activities do
                        count_hash[activity_to_count.activity_type.name] += 1
                    end
                end

                for activity_type in ActivityType.all do
                    score_hash[activity_type.name] *= count_hash[activity_type.name] * 1.0 / this_activity_type.activities.size
                end
            end

            existing_activities = current_user.activities.map{|activity| activity.activity_type.name}
            recommendations = []
            score_hash.sort_by { |activity_name, score| 1.0 - score }.each { |tuple| 
                recommendations << tuple[0] unless existing_activities.include? tuple[0]
            }
            return recommendations
        end

        def num_users
            @num_users ||= User.size
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
end
