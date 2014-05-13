function search() {
    xhr = new XMLHttpRequest();
    xhr.onreadystatechange = xhrHandler;
    var str = document.getElementById('search').value;
    console.log(str);
    if(str) {
        document.getElementById('friends-panel').style.visibility="visible";;   
        document.getElementById('right-panel').style.visibility="visible";;   
    } else {
        document.getElementById('friends-panel').style.visibility="hidden";;   
        document.getElementById('right-panel').style.visibility="hidden";;   
    }
    document.getElementById('friends-header').innerHTML = str;
    var graph_header = document.getElementById('graph-header').innerHTML = str;
    var url = '/searchjson?str=';    
    xhr.open("GET", url+encodeURIComponent(str), true);
    xhr.send();
    function xhrHandler() {
        if (this.readyState != 4) {
            return;
        }
        if (this.status != 200) {
            return;
        }
        // console.log(this.responseText);
        json  = this.responseText;
        if(json['user_does_activity']) {
            if(json['friends']) {
                for (friend in json['friends']) {
                    document.getElementById("friends-header").append(friend);
                    document.getElementById("new-activity").style.visibility = "hidden";
                    document.getElementById("add-activity").style.visibility = "visible";
                }
            }
        } else if (json['query_activity_exists']) {
            if(json['friends']) {
                for (friend in json['friends']) {
                    document.getElementById("friends-header").append(friend);
                    document.getElementById("add-activity").style.visibility = "hidden";
                    document.getElementById("new-activity").style.visibility = "visible";
                }
            }
        } else {
                    document.getElementById("add-activity").style.visibility = "hidden";
                    document.getElementById("new-activity").style.visibility = "visible";
        }
        // document.getElementById("friends-header").innerHTML = this.responseText;
    }
}
