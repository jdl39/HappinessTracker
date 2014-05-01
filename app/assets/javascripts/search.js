// function search() {
//     console.log("Hey");
//     console.log(document.getElementById('friends-list'));
//     console.log(document.getElementById('activity-title'));
function search() {
    // xhr = new XMLHttpRequest();
    // xhr.onreadystatechange = xhrHandler;
    var str = document.getElementById('search').value;
    console.log(str);
    var friends_header = document.getElementById('friends-header');
    friends_header.innerHTML = str;
    var graph_header = document.getElementById('graph-header');
    graph_header.innerHTML = str;    
    // xhr.open("GET", url+encodeURIComponent(str), true);
    // xhr.send();
    // function xhrHandler() {
    //   if (this.readyState != 4) {
    //       return;
    //   }
    //   if (this.status != 200) {

    //       return;
    //   }
    //   document.getElementById(resultID).innerHTML= this.responseText;
    // }
}
