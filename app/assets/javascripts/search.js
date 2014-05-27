inputs = [];
prev = '';
displayed_results = [];
str = '';

function search() {
    if(str == document.getElementById('search').value.trim()) return;
    str = document.getElementById('search').value.trim();
    // updateActivityName(str);
    // updateMeasurementNames(["Miles", "Hours"]) // TODO: make this update actually work.
    if(str) {
        set_headers();
    }
    show_form('');
    searchInitial();
    // searchMore();
}

function set_headers(header) {
    var elements = document.getElementsByClassName('activity_header');
    for (var element in elements) {
        if(header) {
            (elements[element]).innerHTML = header;
        } else {
            (elements[element]).innerHTML = str;            
        }
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

        // if(json['user_does_activity']) {
        //     update_friends(json['friends']);
        //     update_graph(json['recent_measurements'], json['measurement_types']);
        //     show_form('add');
        //     update_suggested(json['spellings_sugs'][0]);
        // } else if (json['query_activity_exists']) {
        //     update_friends(json['friends']);
        //     update_graph(json['recent_measurements'], json['measurement_types']);
        //     show_form('new');
        //     update_suggested(json['spellings_sugs'][0]);
        // } else {
        //     update_friends([]);
        //     update_graph(json['recent_measurements'], json['measurement_types']);
        //     show_form('new');
        //     update_suggested(json["spellings_sugs"][0]);
        // }
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
        var results = document.getElementsByClassName('result');
        while(results.length > 0) {
            elem = results[0];
            next_br = elem.nextSibling;
            elem.parentNode.removeChild(elem);
            next_br.parentNode.removeChild(next_br);
        }
        if(json['user_does_activity']) {
            show_form('add');
            update_graph(json['recent_measurements'], json['measurement_types']);
            update_add_form_inputs(json['measurement_types']);
        } else {
            show_form('new');
        }
    }
}

function setChart(recent_measurements, measurement_types) {
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
}

function clear_form_values() {
    document.forms["add_activity"][0].value = "";
    document.forms["add_activity"][1].value = "";
    document.forms["new_activity"][0].value = "";
    document.forms["new_activity"][1].value = "";
    document.getElementById('measure1_error').style.display = "none";
    document.getElementById('measure2_error').style.display = "none";
}

function update_graph(recent_measurements, measurement_types) {
    if(recent_measurements) {
        document.getElementById("graph_box").style.display = 'block';
        setChart(recent_measurements, measurement_types);
    } else {
        document.getElementById("graph_box").style.display = 'none';
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
    document.forms["new_activity"][1].focus();
    document.getElementById('add_new_measurement_button').style.display = 'none';
}

// AJAX request that will submit the new activity meanurements for a tracked activity
function commit_new_measurement_form() {
    var measurements = validate_new_form();
    var cur_str = str;
    var xhr = new XMLHttpRequest();
    var url = "/create_activity?";
    var params = "activity_name=" + encodeURIComponent(selectedStr) + "&measure1=" + encodeURIComponent(measurements[0]) + "&measure2=" + encodeURIComponent(measurements[1]);
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
        update_add_form_inputs(json['measurement_types']);
        show_form('add');
    }
    xhr.send();
}

// AJAX request to backend that will submit the measurements
function commit_add_measurement_form() {
    console.log("Submitting new measurement");

    var measurements = validate_add_form();
    if(measurements == null) return; // form was not properly filled out
    var cur_str = str;
    var xhr = new XMLHttpRequest();
    var url = "/track_activity?";
    var params = "activity_name=" + encodeURIComponent(selectedStr) + "&measure1=" + encodeURIComponent(measurements[0]) + "&measure2=" + encodeURIComponent(measurements[1]);
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
        update_graph(json['recent_measurements'], json['measurement_types']);
    }
    xhr.send();
}

function update_add_form_inputs(measurements) {
    console.log("measurements to be displayed", measurements);
    if(measurements && measurements.length != 0) {
        if(measurements[0]) {
            document.getElementById('input_measure1').innerHTML = measurements[0];
        } else {
            document.getElementById('measure_input1').style.display = 'none';
            document.getElementById('measure1_error').style.display = 'none';
        }
        if(measurements[1]) {
            document.getElementById('input_measure2').innerHTML = measurements[1];
        } else {
            document.getElementById('measure_input2').style.display = 'none';
            document.getElementById('measure2_error').style.display = 'none';
        }
    } else {
        document.getElementById('no_measure').innerHTML = 'This activity requires no measurements.';
        document.getElementById('measure_input1').style.display = 'none';
        document.getElementById('measure_input2').style.display = 'none';
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
    if(document.forms["add_activity"][0].style.display != 'none') {
        if(document.forms["add_activity"][0].value == '') {
            document.getElementById('measure1_error').style.display = 'block';
            error = true;
        }
    }
    if(document.forms["add_activity"][1].style.display != 'none') {
        if(document.forms["add_activity"][1].value == '') {
            document.getElementById('measure2_error').style.display = 'block';
            error = true;
        }
    }
    if(error) {
        return null;
    } else {
        var value_1 = document.forms["add_activity"][0].value;
        var value_1 = document.forms["add_activity"][1].value;
        document.forms["add_activity"][0].value = '';
        document.forms["add_activity"][1].value = '';
        return [value_1, value_2];    
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
