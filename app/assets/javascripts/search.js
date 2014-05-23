inputs = [];
prev = '';
displayed_results = [];

function search() {
    str = document.getElementById('search').value;
    // updateActivityName(str);
    // updateMeasurementNames(["Miles", "Hours"]) // TODO: make this update actually work.
    // console.log(str);
    if(str) {
        set_headers();
    }
    show_form('');
    // hide_panels();
    // show_form('new');
    searchInitial();
    // searchMore();
}

function set_headers() {
    var elements = document.getElementsByClassName('activity_header');
    for (var element in elements) {
        (elements[element]).innerHTML = str;
    }
}

function hide_panels() {
    document.getElementById('friends-panel').style.display = "none";;   
    document.getElementById('right-panel').style.display = "none";;   
}

function searchInitial() {
    console.log("initial search started");
    var cur_str = str;
    if(str == '') {
        update_results([], true);
        return;
    }
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = xhrHandler;
    var url = '/search_data?str=';
    xhr.open("GET", url+encodeURIComponent(str), true); 
    xhr.send();
    function xhrHandler() {
        if(str != cur_str) return;
        if (this.readyState != 4) {
            return;
        }
        if (this.status != 200) {
            return;
        }
        console.log("starting");
        console.log(this.responseText);
        json  = this.responseText;
        json = JSON.parse(json);
        update_results(json['search_results'], true);
    }
    console.log("initial search ended");
}

function searchMore() {
    console.log("more search started");
    var cur_str = str;
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = xhrHandler;
    var url = '/search_more_data?str=';
    xhr.open("GET", url+encodeURIComponent(str), true); 
    xhr.send();
    function xhrHandler() {
        if(str != cur_str) return;
        if (this.readyState != 4) {
            return;
        }
        if (this.status != 200) {
            return;
        }
        console.log("starting");
        console.log(this.responseText);
        json  = this.responseText;
        json = JSON.parse(json);
        update_results(json['search_results'], false);
        if(json['user_does_activity']) {
            update_friends(json['friends']);
            update_graph(json['recent_measurements'], json['measurement_types']);
            show_form('add');
            update_suggested(json['spellings_sugs'][0]);
        } else if (json['query_activity_exists']) {
            update_friends(json['friends']);
            update_graph(json['recent_measurements'], json['measurement_types']);
            show_form('new');
            update_suggested(json['spellings_sugs'][0]);
        } else {
            update_friends([]);
            update_graph(json['recent_measurements'], json['measurement_types']);
            show_form('new');
            update_suggested(json["spellings_sugs"][0]);
        }
    }
    console.log("more search started");
}

function update_results(results, initial) {
    console.log("results", results);
    if(initial) {
        document.getElementById('results').innerHTML = '';
        displayed_results = [];
    }
    for (element in results) {
        console.log("element name", results[element]);
        results_div = document.getElementById('results');
        if(displayed_results.length <= 10) {
            displayed_results.push(results[element][1]);
            var newDiv = document.createElement('div');
            newDiv.innerHTML = results[element][1];
            newDiv.className = newDiv.className + ' result';
            newDiv.addEventListener('click', function(){
                get_data_for_activity(results[element][1]);
            });
            results_div.appendChild(newDiv);
            results_div.appendChild(document.createElement('br'));
        }
    }
    var elem_displayed = false;
    for (element in displayed_results) {
        if(displayed_results[element] == str) elem_displayed = true;
    }
    if(!elem_displayed && str) {
        var newDiv = document.createElement('div');
        newDiv.innerHTML = 'Create This Activity!';
        newDiv.className = newDiv.className + ' result createNewActivity';
        newDiv.addEventListener('click', function(){
            create_new_activity(str);
        });
        results_div.appendChild(newDiv);
        results_div.appendChild(document.createElement('br'));
    }
}

function create_new_activity(new_activity_str) {
    console.log("hey there once again.", new_activity_str);
    show_form('new');
}

function get_data_for_activity(selectedStr) {
    console.log("hey", selectedStr);
    var cur_str = str;
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = xhrHandler;
    var url = '/search_get_specific_data?str=';
    xhr.open("GET", url+encodeURIComponent(str), true); 
    xhr.send();
    function xhrHandler() {
        if(str != cur_str) return;
        if (this.readyState != 4) {
            return;
        }
        if (this.status != 200) {
            return;
        }
        console.log("starting");
        console.log(this.responseText);
        json  = this.responseText;
        json = JSON.parse(json);
    }
    show_form('add');
}

function show_form(option) {
    if(option == "add") {
        console.log('add');
        document.forms["add_activity"].style.display = "block";
        document.forms["new_activity"].style.display = "none";
        clear_form_values();
        document.getElementById('add_new_measurement_button').style.display = 'block';
    } else if(option == "new") {
        document.forms["add_activity"].style.display = "none";
        document.forms["new_activity"].style.display = "block";
        clear_form_values();
        document.getElementById('add_new_measurement_button').style.display = 'block';
    } else if(option == '') {
        document.forms["add_activity"].style.display = "none";
        document.forms["new_activity"].style.display = "none";
        clear_form_values();
        document.getElementById('add_new_measurement_button').style.display = 'none';
    }
}

function clear_form_values() {
    document.forms["add_activity"][0].value = "";
    document.forms["add_activity"][1].value = "";
    document.forms["new_activity"][0].value = "";
    document.forms["new_activity"][1].value = "";
}

function update_graph(recent_measurements, measurement_types) {
    if(measurement_types) { // doesn't work well on seeds because seeds are set up incorrectly.
        document.getElementById("graph").style.display = 'block';
    } else {
        document.getElementById("graph").style.display = 'none';
    }
}

function update_friends(friends) {
    document.getElementById('friends-list').innerHTML = '';
    if(friends) {
        for (friend in json['friends']) {
            document.getElementById("friends-list").append('<p><%= friend %></p>');
        }
    } else {
        document.getElementById("friends-list").append('<p>None of your friends '+str+'.</p>');
    }
}

function update_suggested(suggestedName) {
    console.log(suggestedName);
    if(suggestedName) {
        console.log(suggestedName);
        document.getElementById('suggested').innerHTML = "Did you mean "+suggestedName+"?";
    } else if(suggestedName == str) {
        document.getElementById('suggested').innerHTML = "";
    } else {
        document.getElementById('suggested').innerHTML = "";
    }
}

function add_measurement_form() {
    document.getElementById('second_measurement').style.display = 'block';
    document.getElementById('add_new_measurement_button').style.display = 'none';
}

// AJAX request that will submit the new activity meanurements for a tracked activity
function commit_new_measurement_form() {
    validate_form();
    show_form('add');
}

// AJAX request to backend that will submit the measurements
function commit_add_measurement_form() {

}

// method that will check the two measurement forms that are submitted through ajax on this page
function validate_form() {

}


// SAMPLE RESPONSE

// {"query_activity_exists":true,
// "user_does_activity":true,
// "search_results":[{"id":1,"name":"running","num_users":2,"created_at":"2014-05-15T03:09:07.591Z","updated_at":"2014-05-15T03:09:09.507Z"},
// {"id":7,"name":"playing guitar","num_users":3,"created_at":"2014-05-15T03:09:07.781Z","updated_at":"2014-05-15T03:09:09.420Z"},
// {"id":11,"name":"playing video games","num_users":1,"created_at":"2014-05-15T03:09:07.881Z","updated_at":"2014-05-15T03:09:09.401Z"},
// {"id":14,"name":"playing pool","num_users":0,"created_at":"2014-05-15T03:09:07.955Z","updated_at":"2014-05-15T03:09:07.955Z"},
// {"id":45,"name":"going for walks","num_users":0,"created_at":"2014-05-15T03:09:08.902Z","updated_at":"2014-05-15T03:09:08.902Z"},
// {"id":47,"name":"made work enjoyable","num_users":0,"created_at":"2014-05-15T03:09:08.954Z","updated_at":"2014-05-15T03:09:08.954Z"}],
// "friends":[],
// "measurement_types":[],
// "recent_measurements":[],
// "spellings_sugs":[null]}
