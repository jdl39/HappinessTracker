inputs = [];
prev = '';
displayed_results = [];
str = '';

function search(enterPress) {
    console.log('enterPress', enterPress);
    if(str == document.getElementById('search').value.trim()) {
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
    // searchMore();
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
    }
    console.log("more search started");
}

function update_results(results, initial) {
    console.log("results", results);
    if(initial) {
        document.getElementById('results').innerHTML = '';
        displayed_results = [];
    }
    var results_div = document.getElementById('results');
    for (var element in results) {
        !function outer(element) {
            console.log("element name", results[element][1]);
            if(displayed_results.length <= 10) {
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
        results_div.appendChild(newDiv);
        results_div.appendChild(document.createElement('br'));
    }
}

function create_new_activity(new_activity_str) {
    console.log("hey there once again.", new_activity_str);
    selectedStr = new_activity_str;
    show_form('new');
    document.getElementById('results').innerHTML = '';
}

function get_data_for_activity(selected_str) {
    console.log("hey", selected_str);
    selectedStr = selected_str;
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
        document.getElementById('results').innerHTML = '';
        if(json['user_does_activity']) {
            show_form('add');
            data = [json['recent_measurements'], json['measurement_types']]
            update_graph();
            measurements = [];
            if(json['measurement_types'][0]) {
                measurements.push(json['measurement_types'][0][1]);
            }
            if(json['measurement_types'][1]) {
                measurements.push(json['measurement_types'][1][1]);
            }
            update_add_form_inputs(measurements);
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






    if(measurement_types[0] != "") {
        if(measurement_types[1] != "") { // 2 measurements used
            console.log("2 measurements");

        } else { // 1 measurement used
            console.log("1 measurements");


        }
    } else { // 0 mesurements used
        console.log("0 measurements");


    }

    new Highcharts.Chart({
        chart: { renderTo: 'activity_chart' }, // name of div to be filled with content
        title: { text: str }, // title of current activity
        xAxis: { type: 'datetime' }, // x axis will be based on time
        yAxis: [{ // Primary yAxis
            labels: {
                format: '{value}°C',
                style: {
                    color: Highcharts.getOptions().colors[2]
                }
            },
            title: {
                text: 'measure2',
                style: {
                    color: Highcharts.getOptions().colors[2]
                }
            },
            opposite: true

        }, { // Secondary yAxis
            gridLineWidth: 0,
            title: {
                text: 'measure1',
                style: {
                    color: Highcharts.getOptions().colors[0]
                }
            },
            labels: {
                format: '{value} mm',
                style: {
                    color: Highcharts.getOptions().colors[0]
                }
            }

        }],
        series: [{
            data: [1, 2, 5, 7, 3]
        }]
    });
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

// Update suggested 
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
        data = [[], json['measurement_types']]
        document.getElementById('commit_new_measurement_button').disabled = false;
    }
    xhr.send();
}

// AJAX request to backend that will submit the measurements
function commit_add_measurement_form() {
    console.log("Submitting new measurement");
    document.getElementById('commit_add_measurement_button').disabled = true;
    var measurements = validate_add_form();
    if(measurements == null) return; // form was not properly filled out
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
        json  = this.responseText;
        json = JSON.parse(json);
        console.log('new measure to add', json['new_measurements']);
        data[0].concat(json['new_measurements']);
        document.getElementById('commit_add_measurement_button').disabled = false;
        update_graph();
    }
    xhr.send();
}

function update_add_form_inputs(measurements) {
    console.log("measurements to be displayed", measurements);
    document.getElementById('commit_new_measurement_button').disabled = false;
    if(measurements[0] != "" || measurements[1] != "") {
        console.log("length", measurements.length);
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
    if(document.forms["add_activity"][0].style.display != 'none' && document.forms["add_activity"][1].style.display != '') {
        if(document.forms["add_activity"][0].value == '') {
            document.getElementById('measure1_error').style.display = 'block';
            error = true;
        }
    }
    if(document.forms["add_activity"][1].style.display != 'none' && document.forms["add_activity"][1].style.display != '') {
        if(document.forms["add_activity"][1].value == '') {
            document.getElementById('measure2_error').style.display = 'block';
            error = true;
        }
    }
    if(error) {
        return null;
    } else {
        var measure1 = document.getElementById('input_measure1').innerHTML;
        var measure2 = document.getElementById('input_measure2').innerHTML;
        var value_1 = document.forms["add_activity"][0].value;
        var value_2 = document.forms["add_activity"][1].value;
        document.forms["add_activity"][0].value = '';
        document.forms["add_activity"][1].value = '';
        return [[measure1, value_1], [measure2, value_2]];    
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
