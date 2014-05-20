inputs = [];
prev = '';

function search() {
    str = document.getElementById('search').value;
    console.log(str);
    if(str) {
        set_headers();
    }
    show_panels();
    show_form('new');
    ajaxSearch();
}

function set_headers() {
    var elements = document.getElementsByClassName('activity_header');
    for (var element in elements) {
        (elements[element]).innerHTML = str;
    }
}

function show_panels() {
    if(str) {
        document.getElementById('friends-panel').style.visibility = "visible";;   
        document.getElementById('right-panel').style.visibility = "visible";;   
    } else {
        document.getElementById('friends-panel').style.visibility = "hidden";;   
        document.getElementById('right-panel').style.visibility = "hidden";;   
    } 
}

function ajaxSearch() {
    console.log("hey");
    var cur_str = str;
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = xhrHandler;
    var url = '/searchjson?str=';
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
        if(json['user_does_activity']) {
            update_friends(json['friends']);
            update_graph(json['recent_measurements'], json['measurement_types']);
            show_form('add');
        } else if (json['query_activity_exists']) {
            update_friends(json['friends']);
            update_graph(json['recent_measurements'], json['measurement_types']);
            show_form('new');
        } else {
            update_friends([]);
            update_graph(json['recent_measurements'], json['measurement_types']);
            show_form('new');
        }
    }
}

function show_form (option) {
    if(option == "add") {
        document.getElementById("add-activity").style.display = "block";
        document.getElementById("new-activity").style.display = "none";
        document.getElementById("add-activity")[0].value = ""
        document.getElementById("add-activity")[1].value = ""
        document.getElementById("new-activity")[0].value = ""
        document.getElementById("new-activity")[1].value = ""
        document.getElementById('add_new_measurement_button').style.display = 'block';
    } else if(option == "new") {
        document.getElementById("add-activity").style.display = "none";
        document.getElementById("new-activity").style.display = "block";
        document.getElementById("add-activity")[0].value = ""
        document.getElementById("add-activity")[1].value = ""
        document.getElementById("new-activity")[0].value = ""
        document.getElementById("new-activity")[1].value = ""
        document.getElementById('add_new_measurement_button').style.display = 'block';
    }
}

function update_graph(recent_measurements, measurement_types) {
    if(recent_measurements && measurement_types) { // doesn't work well on seeds because seeds are set up incorrectly.
        document.getElementById("graph").style.visibility = 'visible';
    } else {
        document.getElementById("graph").style.visibility = 'hidden';
    }
}

function update_friends (friends) {
    // clear friends
    if(friends) {
        document.getElementById('')
        for (friend in json['friends']) {
            document.getElementById("friends-list").innerHTML = '<p><%= friend %></p>';
        }
    } else {

    }
}

function add_measurement_form() {
    document.getElementById('second_measurement').style.visibility = 'visible';
    document.getElementById('commit_new_measurement_button').style.visibility = 'visible';
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
