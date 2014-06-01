var ready = function setStartingParam() {
    console.log("happiness page is loaded");
    if(!document.getElementById('happiness')) return;
    Highcharts.getOptions().colors = Highcharts.map(Highcharts.getOptions().colors, function(color) {
        return {
            linearGradient: { x1: 0, x2: 0, y1: 0, y1: 1 },
             stops: [
                [0, Highcharts.Color(color).brighten(-0.3).get('rgb')], // darken
                [1, Highcharts.Color(color).brighten(0.1).get('rgb')]
            ]
        };
    });
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = xhrHandler;
    var url = '/happiness_scores';
    xhr.open("GET", url, true); 
    xhr.send();
    function xhrHandler() {
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
        var scores = [];
        for(score in json) {
            scores.push(parseFloat(json[score]['value']));
        }
        var cur = new Date(), start = cur.setDate(cur.getDate() -90);       
        new Highcharts.Chart({
            chart: {
                renderTo: 'happiness_graph',
                zoomType: 'x'
            },
            title: {
                text: 'Your Happiness Score History'
            },
            subtitle: {
                text: document.ontouchstart === undefined ?
                'Click and drag in the plot area to zoom in' :
                'Pinch the chart to zoom in'
            },
            xAxis: [{
                name: 'Scores Over Last 90 Days',
                type: 'datetime',
                minRange: 1 * 24 * 3600000 // fourteen days
            }],
            yAxis: {
                title: {
                    text: "Happiness Score %",
                }
            },
            legend: {
                floating: false,
                backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'
            },
            series: [{
                name: "Score",
                type: 'areaspline',
                color: Highcharts.getOptions().colors[3],
                pointInterval: 24 * 3600 * 1000,
                pointStart: start,
                data: scores
            }]
        });
        console.log("happiness scores returned");
    }
}

$(document).ready(ready);
$(document).on('page:load', ready);
