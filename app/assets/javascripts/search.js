// Global Variables
inputs = [];
prev = '';
displayed_results = [];
str = '';
doNotUpdateSearchMore = false;
searchTimeoutFn = null;
activity_id = 0;
all_friends = null;

// Page initiation function
var ready = function setStartingParam() {
    if(!document.getElementById('search')) return;
    console.log("search page is loaded");
    var len = document.getElementById('search').value.length;
    document.getElementById('search').focus();
    document.getElementById('search').setSelectionRange(len, len);
    search();
    document.getElementById('search').onkeyup = function(e) {
        if (!e) e = window.event;
        var keyCode = e.keyCode || e.which;
        if (keyCode == '13' && document.getElementById('search').value.trim() != ""){ // Enter pressed
            console.log('entered pressed');
            pickIfMatching();                  
        } else {
            console.log('search now');
            search();
        }
    }
    document.getElementById('add_activity_1').onkeyup = function(e) {
        input_str = document.getElementById('add_activity_1').value.trim();
        if (input_str == "" || /^\d+$/.test(input_str)) {
            document.getElementById('measure1_num_only').style.display = "none";
            if(document.getElementById('measure2_num_only').style.display == '' || document.getElementById('measure2_num_only').style.display == 'none') {
                document.getElementById('commit_add_measurement_button').disabled = false;
            }
        } else {
            document.getElementById('measure1_num_only').style.display = "block";
            document.getElementById('commit_add_measurement_button').disabled = true;
        }
    }
    document.getElementById('add_activity_2').onkeyup = function(e) {
        input_str = document.getElementById('add_activity_2').value.trim();
        if (input_str == "" || /^\d+$/.test(input_str)) {
            document.getElementById('measure2_num_only').style.display = "none";
            if(document.getElementById('measure1_num_only').style.display == '' || document.getElementById('measure1_num_only').style.display == 'none') {
                document.getElementById('commit_add_measurement_button').disabled = false;
            }
        } else {
            document.getElementById('measure2_num_only').style.display = "block";
            document.getElementById('commit_add_measurement_button').disabled = true;
        }
    }
    document.getElementById('friends_search').onkeyup = function(e) {
        update_friends_list();
    }
}

$(document).ready(ready);
$(document).on('page:load', ready);

// Main search function that controlls flow of search
function search() {
    console.log("str", str);
    if(str && str == document.getElementById('search').value.trim()) {
        console.log("still same string", str);
        return;
    }
    if(typeof searchTimeoutFn != 'undefined') {
        console.log("skip previous one.", str);
        clearTimeout(searchTimeoutFn);
    }
    str = document.getElementById('search').value.trim();
    if(str) {
        set_headers();
    }
    set_form('');
    searchTimeoutFn = setTimeout(searchInitial, 200);
}

// Will select first available option from choices presented
function pickIfMatching() {
    if(displayed_results[0]) {
        get_data_for_activity(displayed_results[0]);
    } else {
        create_new_activity(document.getElementById('search').value.trim());
    }
}

// Sets all headers in page that reference the selected activity
function set_headers(header) {
    var elements = document.getElementsByClassName('activity_header');
    for (var element in elements) {
        if(header) (elements[element]).innerHTML = header.capitalize();
        else (elements[element]).innerHTML = str.capitalize();
    }
}

// Preforms the initial function for quick search
function searchInitial() {
    console.log("initial search started");
    doNotUpdateSearchMore = false;
    var cur_str = str;
    if(str == '') {
        update_results([], true);
        document.getElementsByClassName("loading-indicator")[0].style.display = "none";
        return;
    }
    document.getElementById('results').innerHTML = '';
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = xhrHandler;
    var url = '/search_data?str=';
    console.log(url + encodeURIComponent(str));
    xhr.open("GET", url + encodeURIComponent(str), true); 
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
        json = this.responseText;
        json = JSON.parse(json);
        update_results(json['search_results'], true);
        searchMore();
        console.log("initial search ended");
    }
}

// A more complete search that finds other options
function searchMore() {
    console.log("more search started");

    document.getElementsByClassName("loading-indicator")[0].style.display = "block";

    var cur_str = str;
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = xhrHandler;
    var url = '/search_more_data?str=';
    xhr.open("GET", url  +encodeURIComponent(str), true); 
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
        json = this.responseText;
        json = JSON.parse(json);
        if(!doNotUpdateSearchMore) {
            update_results(json['search_results'], false);
        }
        doNotUpdateSearchMore = true;
        document.getElementsByClassName("loading-indicator")[0].style.display = "none";
        console.log("more search ended");        
    }
}

// Will update drop down list of available options
function update_results(results, initial) {
    console.log("results", results);
    if(initial) {
        document.getElementById('results').innerHTML = '';
        displayed_results = [];
    } else {
        var div = document.getElementById('create_activity_div');
        if(div) {
            div.parentNode.removeChild(div.nextSibling);
            div.parentNode.removeChild(div);
        }
    }
    var results_div = document.getElementById('results');
    for (var element in results) {
        !function outer(element) {
            console.log("element name", results[element][1]);
            if(displayed_results.length <= 10 && displayed_results.indexOf(results[element][1]) == -1) {
                displayed_results.push(results[element][1]);
                var newDiv = document.createElement('div');
                newDiv.innerHTML = results[element][1];
                newDiv.className = newDiv.className + ' result';
                var i = results[element][1];
                newDiv.addEventListener('click', function() {
                    get_data_for_activity(i);
                });
                results_div.appendChild(newDiv);
                results_div.appendChild(document.createElement('br'));
            }
        }(element);
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
        newDiv.id = "create_activity_div";
        results_div.appendChild(newDiv);
        results_div.appendChild(document.createElement('br'));
    }
}

// Clears drop down list and sets the new measurement list
function create_new_activity(new_activity_str) {
    selectedStr = new_activity_str;
    doNotUpdateSearchMore = true;
    set_form('new');
    document.getElementById('results').innerHTML = '';
}

function get_data_for_activity(selected_str) {
    hide_goal_form();
    hide_comment_area();
    console.log("hey", selected_str);
    selectedStr = selected_str;
    document.getElementById('results').innerHTML = '';
    doNotUpdateSearchMore = true;
    document.getElementsByClassName("loading-indicator")[0].style.display = "none";
    str = selected_str;
    document.getElementById('search').value = selected_str;
    set_headers(selected_str);
    var cur_str = str;
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = xhrHandler;
    var url = '/search_get_specific_data?str=';
    xhr.open("GET", url + encodeURIComponent(selected_str), true); 
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
        json = this.responseText;
        json = JSON.parse(json);
        display_comment_area(json.activity_id);
        if(json['user_does_activity']) {
            set_form('add');
            measurements = [];
            if(json['measurement_types'][0]) {
                measurements.push(json['measurement_types'][0][1]);
            }
            if(json['measurement_types'][1]) {
                measurements.push(json['measurement_types'][1][1]);
            }
            update_add_form_inputs(measurements);
            data = [json['recent_measurements'], parseMeasurements(json['measurement_types'])];
            update_graph();
            display_goal_form(selected_str, measurements);
        } else {
            set_form('new');
        }
    }
}

// Controls if graph is shown or not based on whether there is any data to show
function update_graph() {
    console.log("data", data);
    if(data[0].length > 0) {
        console.log("Show the graph with information", data[0]);
        document.getElementById("graph_box").style.display = 'block';
        setChart(data[0], data[1]);
    } else {
        console.log("Hide the graph", data[0]);
        document.getElementById("graph_box").style.display = 'none';
    }
}

// Chart configurations for each of three different measurement options
function setChart(recent_measurements, measurement_types) {
    // console.log("final data", recent_measurements);
    console.log("measurement_types", measurement_types);

    if(measurement_types[0][0] != 1) {
        console.log("2 measurements");
        var categories = [];
        if(measurement_types[1][0] != 1) { // 2 measurements used
            var strict_data = [[], []];
            for(recent_measurement in recent_measurements) {
                var created = recent_measurements[recent_measurement]['created_at'];
                splitDate = created.split(" ");
                var dayOfWeek = splitDate[0];
                var month = splitDate[1];
                var day = parseFloat(splitDate[2]);
                var year = parseFloat(splitDate[3]);
                var shortenStr = dayOfWeek + ' ' + month + ' ' + day + ', ' + year;
                var newElem = parseFloat(recent_measurements[recent_measurement]['value']);
                if(parseFloat(recent_measurements[recent_measurement]['measurement_type_id']) == measurement_types[0][0]) {
                    strict_data[0].push(newElem);
                    categories.push(shortenStr);                    
                } else if(parseFloat(recent_measurements[recent_measurement]['measurement_type_id']) == measurement_types[1][0]) {
                    strict_data[1].push(newElem);
                } else {
                    console.log("no matches ERROR");
                }
            }        
            console.log("categories", categories);
            console.log("strict_data", strict_data);
            new Highcharts.Chart({
                chart: {
                    renderTo: 'activity_chart',
                    zoomType: 'x'
                },
                title: {
                    text: 'Your History of ' + str.capitalize()
                },
                subtitle: {
                    text: document.ontouchstart === undefined ?
                    'Click and drag in the plot area to zoom in' :
                    'Pinch the chart to zoom in'
                },
                xAxis: [{
                    categories: categories
                }],
                yAxis: [{ // Primary yAxis
                    title: {
                        text: measurement_types[0][1].capitalize(),
                    }
                }, { // Secondary yAxis
                    title: {
                        text: measurement_types[1][1].capitalize(),
                    },
                    opposite: true
                }],
                legend: {
                    floating: false,
                    backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'
                },
                series: [{
                    name: measurement_types[0][1].capitalize(),
                    type: 'column',
                    data: strict_data[0]
                }, {
                    name: measurement_types[1][1].capitalize(),
                    type: 'column',
                    yAxis: 1,
                    data: strict_data[1]
                }]
            });
        } else { // 1 measurement used
            var categories = [];
            var graph_data = [[], []];
            for(recent_measurement in recent_measurements) {
                var created = recent_measurements[recent_measurement]['created_at'];
                // splitDate = created.split(" ");
                // var dayOfWeek = splitDate[0];
                // var month = splitDate[1];
                // var day = parseFloat(splitDate[2]);
                // var year = parseFloat(splitDate[3]);
                // var shortenStr = dayOfWeek + ' ' + month + ' ' + day + ', ' + year; 
                // console.log("stuffs", dayOfWeek, year, month, day);

                var newElem = parseFloat(recent_measurements[recent_measurement]['value']);
                if(parseFloat(recent_measurements[recent_measurement]['measurement_type_id']) == measurement_types[0][0]) {
                    graph_data[0].push(newElem);
                    categories.push(created);
                } else if(parseFloat(recent_measurements[recent_measurement]['measurement_type_id']) == measurement_types[1][0]) {
                    // ignore
                } else {
                    console.log("no matches ERROR");
                }
            }
            console.log("graph_data", graph_data);
            console.log("categories", categories);            
            console.log("1 measurements");

            new Highcharts.Chart({
                chart: {
                    renderTo: 'activity_chart',
                    zoomType: 'x',
                    type: 'areaspline',
                    style: {
                        fontFamily: 'Book Antiqua'
                    }
                },
                title: {
                    text: 'Your History of ' + str.capitalize()
                },
                subtitle: {
                    text: document.ontouchstart === undefined ?
                    'Click and drag in the plot area to zoom in' :
                    'Pinch the chart to zoom in'
                },
                xAxis: {
                    type: 'category',
                    categories: categories,
                    title: {
                        text: 'Date'
                    }
                },
                yAxis: {
                    title: {
                        text: measurement_types[0][1].capitalize()
                    },
                    min: 0
                },
                series: [{
                    name: measurement_types[0][1].capitalize(),
                    color: Highcharts.getOptions().colors[3],
                    data: graph_data[0]
                }]
            });
        }
    } else { // 0 mesurements used
        console.log("0 measurements");
        var categories = [];
        var graph_data = [];
        for(recent_measurement in recent_measurements) {
            var created = recent_measurements[recent_measurement]['created_at'];
            splitDate = created.split(" ");
            var dayOfWeek = splitDate[0];
            var month = splitDate[1];
            var day = parseFloat(splitDate[2]);
            var year = parseFloat(splitDate[3]);
            var shortenStr = dayOfWeek + ' ' + month + ' ' + day + ', ' + year;
            console.log("shortened", shortenStr);
            if(graph_data[0]) {
                if(categories[categories.length - 1] != shortenStr) {
                    graph_data.push(.5);
                    categories.push(shortenStr);
                } else {
                    graph_data[graph_data.length - 1] = graph_data[graph_data.length - 1] + .5;
                }
            } else {
                graph_data[0] = .5;
                categories.push(shortenStr);                    
            }
        }
        console.log("graph_data", graph_data);
        console.log("categories", categories);
        var chart = new Highcharts.Chart({
            chart: {
                renderTo: 'activity_chart',
                zoomType: 'x',
                type: 'column',
                style: {
                    fontFamily: 'Book Antiqua'
                }
            },
            title: {
                text: 'Your History of ' + str.capitalize()
            },
            subtitle: {
                text: document.ontouchstart === undefined ?
                'Click and drag in the plot area to zoom in' :
                'Pinch the chart to zoom in'
            },
            xAxis: {
                type: 'category',
                categories: categories,
                title: {
                    text: 'Dates of Exercises'
                }
            },
            yAxis: {
                title: {
                    text: 'Number of Times Completed per Day'
                },
                min: 0
            },
            series: [{
                name: str.capitalize(),
                color: Highcharts.getOptions().colors[3],
                data: graph_data
            }]
        });
    }
}

//controlls which of the forms to show and resets any forms not visible
function set_form(option) {
    clear_form_values();
    if(option == "new") {
        document.forms["add_activity"].style.display = "none";
        document.forms["new_activity"].style.display = "block";
        document.forms["new_activity"][0].focus();
        document.getElementById('second_measurement').style.display = 'none';
        document.getElementById('add_new_measurement_button').style.display = 'block';
        document.getElementById('graph_box').style.display = 'none';
    } else if(option == "add") { // shows the rest of the forms
        console.log('add');
        document.forms["add_activity"].style.display = "block";
        document.forms["add_activity"][0].focus();
        document.forms["new_activity"].style.display = "none";
        document.getElementById('second_measurement').style.display = 'none';
        document.getElementById('add_new_measurement_button').style.display = 'block';
        document.getElementById('challenge_form').style.display = 'block';
        document.getElementById('commit_challenge_button').disabled = true;
    } else if(option == '') {
        document.forms["add_activity"].style.display = "none";
        document.forms["new_activity"].style.display = "none";
        document.getElementById('add_new_measurement_button').style.display = 'none';
        document.getElementById('second_measurement').style.display = 'none';
        document.getElementById('graph_box').style.display = 'none';
    }
    document.getElementById('commit_new_measurement_button').disabled = false;
}

function clear_form_values() {
    document.forms["add_activity"][0].value = "";
    document.forms["add_activity"][1].value = "";
    document.forms["new_activity"][0].value = "";
    document.forms["new_activity"][1].value = "";
    document.forms["challenge_form"][0].value = "";
    document.forms["challenge_form"][1].value = "";
    document.getElementById('measure1_error').style.display = "none";
    document.getElementById('measure2_error').style.display = "none";
    document.getElementById('challenge_no_friend_error').style.display = "none";
    document.getElementById('challenge_no_message_error').style.display = "none";
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

function add_measurement_form() {
    document.getElementById('second_measurement').style.display = 'block';
    document.forms["new_activity"][1].focus();
    document.getElementById('add_new_measurement_button').style.display = 'none';
}

//--------------------------//
// New Activty Form         //
//--------------------------//

// AJAX request that will submit the new activity measurements for a tracked activity
function commit_new_measurement_form() {
    var measurements = validate_new_form();
    document.getElementById('commit_new_measurement_button').disabled = true;
    var cur_str = str;
    var xhr = new XMLHttpRequest();
    var url = "/create_activity?";
    var params = "activity_name=" + encodeURIComponent(selectedStr) + "&measure1=" + encodeURIComponent(measurements[0]) + "&measure2=" + encodeURIComponent(measurements[1]);
    console.log(url + params);
    xhr.open("GET", url + params, true);
    xhr.onreadystatechange = xhrHandler;
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
        json = this.responseText;
        json = JSON.parse(json);
        data = null;
        set_form('add');

        measurements = [];
        if(json['measurement_types'][0]) {
            measurements.push(json['measurement_types'][0][1]);
        }
        if(json['measurement_types'][1]) {
            measurements.push(json['measurement_types'][1][1]);
        }
        update_add_form_inputs(measurements);
        data = [[], parseMeasurements(json['measurement_types'])];

        console.log("jeremy's new data");
        document.getElementById('commit_new_measurement_button').disabled = false;
    }
    xhr.send();
}

// method that will check the two measurement forms that are submitted through ajax on this page
function validate_new_form() {
    if(!document.forms["new_activity"][0].value && document.forms["new_activity"][1].value) {
       document.forms["new_activity"][0].value = document.forms["new_activity"][1].value;
       document.forms["new_activity"][1].value = '';
    }
    return [document.forms["new_activity"][0].value, document.forms["new_activity"][1].value];
}

function parseMeasurements(measurements) {
    console.log("measurements", measurements);
    if(!measurements) return ['', ''];
    if(measurements[0][0]) parseFloat(measurements[0][0]);
    if(measurements[1][0]) parseFloat(measurements[1][0]);
    return measurements;
}

//--------------------------//
// Add Activity Form        //
//--------------------------//

// AJAX request to backend that will submit the measurements
function commit_add_measurement_form() {
    var measurements = validate_add_form();
    console.log("meas", measurements);
    if(measurements == null) return; // form was not properly filled out
    console.log("Submitting new measurement");
    document.getElementById('commit_add_measurement_button').disabled = true;
    var cur_str = str;
    var xhr = new XMLHttpRequest();
    var url = "/track_activity?";
    var params = "activity_name=" + encodeURIComponent(selectedStr) + "&measure1=" + encodeURIComponent(measurements[0][0]) + '&value1=' + encodeURIComponent(measurements[0][1]) + "&measure2=" + encodeURIComponent(measurements[1][0]) + "&value2=" + encodeURIComponent(measurements[1][1]);
    xhr.open("GET", url + params, true);
    console.log(url + params);
    xhr.onreadystatechange = xhrHandler;
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
        json = this.responseText;
        json = JSON.parse(json);
        console.log('new measure to add', data[0], json['new_measurements']);
        if(data[0].length == 0) {
            console.log('first entered into the activity');
            data[0] = json['new_measurements'];
        } else {
            data[0].push.apply(data[0], json['new_measurements']);
        }
        console.log("new data", data[0]);
        document.getElementById('commit_add_measurement_button').disabled = false;
        update_graph();
    }
    xhr.send();
}

// check if form is properly filled out and returns form data if completed
function validate_add_form() {
    console.log("data at add form", data);
    var  error  = false;
    if(data[1][0][1] != '') {
        if(document.forms["add_activity"][0].value == '') {
            document.getElementById('measure1_error').style.display = 'block';
            console.log("error in add 1");
            error = true;
        } else {
            document.getElementById('measure1_error').style.display = 'none';
        }
    }
    if(data[1][1][1] != '') {
        if(document.forms["add_activity"][1].value == '') {
            document.getElementById('measure2_error').style.display = 'block';
            console.log("error in add 2", data[1][1]);
            error = true;
        } else {
            document.getElementById('measure2_error').style.display = 'none';
        }
    }
    if(error) {
        console.log("error", error);
        return null;
    } else {
        console.log("no error in add form");
        document.getElementById('measure1_error').style.display = 'none';
        document.getElementById('measure2_error').style.display = 'none';
        var measure1 = document.getElementById('input_measure1').innerHTML;
        var measure2 = document.getElementById('input_measure2').innerHTML;
        var value_1 = document.forms["add_activity"][0].value;
        var value_2 = document.forms["add_activity"][1].value;
        document.forms["add_activity"][0].value = '';
        document.forms["add_activity"][1].value = '';
        return [[measure1, value_1], [measure2, value_2]];    
    }
}

function update_add_form_inputs(measurements) {
    console.log("measurements to be displayed", measurements);
    document.getElementById('commit_new_measurement_button').disabled = false;
    if(measurements[0] != '') {
        if(measurements[0] != "") {
            console.log("show first add input");
            document.getElementById('input_measure1').innerHTML = measurements[0];
            document.getElementById('measure_input1').style.display = 'block';
        } else {
            document.getElementById('measure_input1').style.display = 'none';
        }
        if(measurements[1] && measurements[1] != "") {
            console.log("show second add input");
            document.getElementById('input_measure2').innerHTML = measurements[1];
            document.getElementById('measure_input2').style.display = 'block';        
        } else {
            document.getElementById('measure_input2').style.display = 'none';
        }
    } else {
        console.log("no measurements to show");
        document.getElementById('no_measure').innerHTML = 'This activity requires no measurements.';
        document.getElementById('measure_input1').style.display = 'none';
        document.getElementById('measure_input2').style.display = 'none';
        document.getElementById('measure1_error').style.display = 'none';
        document.getElementById('measure2_error').style.display = 'none';
    }
}

//--------------------------//
// Challenge Form           //
//--------------------------//

// Accepts the user submitting a challenge and processes it.
function commit_challenge_form() {
    var cur_str = str;
    var form_data = validate_challenge_form();
    console.log("challenge data", form_data);
    if(form_data == null) return; // form was not properly filled out
    console.log("Submitting new challenge");
    document.getElementById('commit_challenge_button').disabled = true;
    var xhr = new XMLHttpRequest();
    var url = "/new_challenge?";
    var params = "receiver_id=" + encodeURIComponent(form_data['receiver_id']) + "&activity_id=" + encodeURIComponent(form_data['activity_id']) + "&content=" + encodeURIComponent(['content']);
    xhr.open("GET", url + params, true);
    console.log(url + params);
    xhr.onreadystatechange = xhrHandler;
    function xhrHandler() {
        if(str != cur_str) return;
        if (this.readyState != 4) {
            return;
        }
        if (this.status != 200) {
            return;
        }
        console.log("starting", this.responseText);
        clear_challenge_form_on_success();
        document.getElementById('commit_challenge_button').disabled = true;
    }
    xhr.send();
}

function clear_challenge_form_on_success() {
    document.forms["challenge_form"][0].value = "";
    document.forms["challenge_form"][1].value = "";
}


// document.getElementById('challenge_no_friend_error').style.display = "none";
// document.getElementById('challenge_no_message_error').style.display = "none";

function friend_selected(selected_name, selected_id) {
    document.getElementById('commit_challenge_button').disabled = false;
    document.getElementById('friends_search').value = selected_name;
}

function validate_challenge_form() {






    return null;
}

function update_friends_list() {
    clear_friends_results();
    if(all_friends) {
        update_friend_results(available_friends());
    } else {
        get_friends();
    }
}

function clear_friends_results() {
    document.getElementById('commit_challenge_button').disabled = true;
    var friends_displayed = document.getElementById('friends_for_challenge_list'); 
    friends_displayed.innerHTML = '';
}

function get_friends() {
    console.log("all_friends before", all_friends);
    if(all_friends == null) {
        console.log("Checking for all friends");
        var xhr = new XMLHttpRequest();
        var url = "/get_my_friends?";
        xhr.open("GET", url, true);
        xhr.onreadystatechange = xhrHandler;
        function xhrHandler() {
            if (this.readyState != 4) {
                return;
            }
            if (this.status != 200) {
                return;
            }
            console.log("starting: friends", this.responseText);
            json = this.responseText;
            json = JSON.parse(json)
            all_friends = json;
            update_friend_results(available_friends());
        }
        xhr.send();
    }
}

function available_friends() {
    var search_str = document.getElementById('friends_search').value.trim();
    console.log("all_friends", all_friends, "search_str", search_str);
    var available_friends = [];
    for(friends in all_friends) {
        var cur_friend = all_friends[friends];
        if(cur_friend.fullname.toLowerCase().indexOf(search_str.toLowerCase()) != -1) {
            available_friends.push([cur_friend.fullname, cur_friend.id]);
        }
    }
    console.log("available_friends from fn", available_friends);
    return available_friends;
}

function update_friend_results(available_friends) {
    console.log("available_friends", available_friends);

    var results_div = document.getElementById('friends_for_challenge_list');
    for (var friend in available_friends) {
        !function outer(friend) {
            console.log("friend name", available_friends[friend]);
            var newDiv = document.createElement('div');
            newDiv.innerHTML = available_friends[friend][0].capitalize();
            newDiv.className = newDiv.className + ' friend_result';
            var i = available_friends[friend];
            newDiv.addEventListener('click', function() {
                friend_selected(i[0], i[1]);
            });
            results_div.appendChild(newDiv);
        }(friend);
    }
}

//--------------------------//
// Goals and comments       //
//--------------------------//
function display_goal_form(activity_name, measurement_names) {
    updateActivityName(activity_name)
    updateMeasurementNames(measurement_names)
    document.getElementsByClassName("goal-area")[0].style.display = "inline";

}
function hide_goal_form() {
    document.getElementsByClassName("goal-area")[0].style.display = "none";
}

function display_comment_area(displayed_activity_id) {
    document.getElementById("comment_system").style.display = "inline";
    load_new_comments(displayed_activity_id);
}
function hide_comment_area() {
    reset_comment_area();
    document.getElementById("comment_system").style.display = "none";
}

//--------------------------//
// MISC.                    //
//--------------------------//
String.prototype.capitalize = function() {
    return this.charAt(0).toUpperCase() + this.slice(1);
}
