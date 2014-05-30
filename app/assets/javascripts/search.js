inputs = [];
prev = '';
displayed_results = [];
str = '';
doNotUpdateSearchMore = false;


var ready = function setStartingParam() {
    console.log("page is loaded");
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
}

$(document).ready(ready);
$(document).on('page:load', ready);

function search() {
    console.log("str", str);
    if(str && str == document.getElementById('search').value.trim()) {
        console.log("still same string", str);
        return;
    }
    str = document.getElementById('search').value.trim();
    // updateMeasurementNames(["Miles", "Hours"]) // TODO: make this update actually work.
    if(str) {
        set_headers();
    }
    show_form('');
    searchInitial();
}

function pickIfMatching() {
    if(displayed_results[0]) {
        get_data_for_activity(displayed_results[0]);
    } else {
        create_new_activity(document.getElementById('search').value.trim());
    }
}

function set_headers(header) {
    var elements = document.getElementsByClassName('activity_header');
    for (var element in elements) {
        if(header) (elements[element]).innerHTML = header;
        else (elements[element]).innerHTML = str;
    }
}

function searchInitial() {
    console.log("initial search started");
    doNotUpdateSearchMore = false;
    var cur_str = str;
    if(str == '') {
        update_results([], true);
        return;
    }
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
        json  = this.responseText;
        json = JSON.parse(json);
        update_results(json['search_results'], true);
        searchMore();
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
        if(!doNotUpdateSearchMore) {
            update_results(json['search_results'], false);
        }
        doNotUpdateSearchMore = true;
        console.log("more search ended");        
    }
}

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

function create_new_activity(new_activity_str) {
    console.log("hey there once again.", new_activity_str);
    selectedStr = new_activity_str;
    doNotUpdateSearchMore = true;
    show_form('new');
    document.getElementById('results').innerHTML = '';
}

function get_data_for_activity(selected_str) {
    console.log("hey", selected_str);
    selectedStr = selected_str;
    document.getElementById('results').innerHTML = '';
    doNotUpdateSearchMore = true;
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
        json  = this.responseText;
        json = JSON.parse(json);
        if(json['user_does_activity']) {
            show_form('add');
            measurements = [];
            if(json['measurement_types'][0]) {
                measurements.push(json['measurement_types'][0][1]);
            }
            if(json['measurement_types'][1]) {
                measurements.push(json['measurement_types'][1][1]);
            }
            update_add_form_inputs(measurements);
            data = [json['recent_measurements'], measurements];
            update_graph();
        } else {
            show_form('new');
        }
    }
}

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

function setChart(recent_measurements, measurement_types) {
    console.log("final data", recent_measurements, measurement_types);
    if(measurement_types[0] != "") {
        if(measurement_types[1] != "") { // 2 measurements used
            console.log("2 measurements");
            new Highcharts.Chart({
                chart: {
                    renderTo: 'activity_chart',
                    zoomType: 'x'
                },
                title: {
                    text: 'Your History of ' + str
                },
                subtitle: {
                    text: document.ontouchstart === undefined ?
                    'Click and drag in the plot area to zoom in' :
                    'Pinch the chart to zoom in'
                },
                xAxis: {
                    type: 'datetime',
                    tickInterval: 24 * 3600 * 1000
                    // minRange: 1 * 24 * 3600000 // 1 day
                },
                yAxis: [{ // Primary yAxis
                    gridLineWidth: 0,
                    abels: {
                        format: '{value}',
                        style: {
                            color: Highcharts.getOptions().colors[5]
                        }
                    },
                    title: {
                        text: measurement_types[0],
                        style: {
                            color: Highcharts.getOptions().colors[5]
                        }
                    },
                    opposite: false

                },  { // Secondary yAxis
                    labels: {
                        format: '{value}',
                        style: {
                            color: Highcharts.getOptions().colors[2]
                        }
                    },
                    title: {
                        text: measurement_types[1],
                        style: {
                            color: Highcharts.getOptions().colors[2]
                        }
                    },
                    opposite: true

                }],
                tooltip: {
                    shared: true
                },
                legend: {
                    floating: false,
                    backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'
                },
                series: [{
                    name: measurement_types[0], // series for measure 1
                    type: 'spline',
                    pointInterval:  3600 * 1000,
                    // pointStart: Date(2014, 4, 01, 0, 0, 0, 0),
                    data: [7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6]
                },  {
                    name: measurement_types[1], // series for measure 2
                    type: 'spline',
                    pointInterval:  3600 * 1000,
                    yAxis: 1,
                    data: [49.9, 71.5, 106.4, 129.2, 144.0, 176.0, 135.6, 148.5, 216.4, 194.1, 95.6, 54.4]
                }]
            });

        } else { // 1 measurement used
            console.log("1 measurements");


        }
    } else { // 0 mesurements used
        console.log("0 measurements");


    }
}

function show_form(option) {
    if(option == "add") {
        console.log('add');
        document.forms["add_activity"].style.display = "block";
        document.forms["add_activity"][0].focus();
        document.forms["new_activity"].style.display = "none";
        clear_form_values();
        document.getElementById('second_measurement').style.display = 'none';
        document.getElementById('add_new_measurement_button').style.display = 'block';
    } else if(option == "new") {
        document.forms["add_activity"].style.display = "none";
        document.forms["new_activity"].style.display = "block";
        document.forms["new_activity"][0].focus();
        clear_form_values();
        document.getElementById('second_measurement').style.display = 'none';
        document.getElementById('add_new_measurement_button').style.display = 'block';
        document.getElementById('graph_box').style.display = 'none';
    } else if(option == '') {
        document.forms["add_activity"].style.display = "none";
        document.forms["new_activity"].style.display = "none";
        clear_form_values();
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
    document.getElementById('measure1_error').style.display = "none";
    document.getElementById('measure2_error').style.display = "none";
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
        json  = this.responseText;
        json = JSON.parse(json);
        data = null;
        update_add_form_inputs(measurements);
        show_form('add');
        data = [[], measurements];
        document.getElementById('commit_new_measurement_button').disabled = false;
    }
    xhr.send();
}

// AJAX request to backend that will submit the measurements
function commit_add_measurement_form() {
    var measurements = validate_add_form();
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
        // console.log(this.responseText);
        json  = this.responseText;
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

function update_add_form_inputs(measurements) {
    console.log("measurements to be displayed", measurements);
    document.getElementById('commit_new_measurement_button').disabled = false;
    if(measurements[0] != "") {
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

// method that will check the two measurement forms that are submitted through ajax on this page
function validate_new_form() {
    if(!document.forms["new_activity"][0].value && document.forms["new_activity"][1].value) {
       document.forms["new_activity"][0].value = document.forms["new_activity"][1].value;
       document.forms["new_activity"][1].value = '';
    }
    return [document.forms["new_activity"][0].value, document.forms["new_activity"][1].value];
}

// check if form is properly filled out and returns form data if completed
function validate_add_form() {
    var  error  = false;
    if(data[1][0] != '') {
        if(document.forms["add_activity"][0].value == '') {
            document.getElementById('measure1_error').style.display = 'block';
            error = true;
        } else {
            document.getElementById('measure1_error').style.display = 'none';
        }
    }
    if(data[1][1] != '') {
        if(document.forms["add_activity"][1].value == '') {
            document.getElementById('measure2_error').style.display = 'block';
            error = true;
        } else {
            document.getElementById('measure2_error').style.display = 'none';
        }
    }
    if(error) {
        return null;
        console.log("error", error);
    } else {
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

// Update suggested // for now we are not using a suggestion for user input
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
