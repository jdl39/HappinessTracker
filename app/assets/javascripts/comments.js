// TODO: create reply buttons for creating (1) activity comment (2) response to comment (3) response (pm) to a response

function load_new_comments(activity_type_id) {
// TODO: show upvote
    $.get( "get_comments?activity_type_id=" + activity_type_id + "&num_needed=3", function( data ) {
        for(var i = 0; i < data["new_comments"].length; i++) {
            var box = new_comment_box(data["new_comments"][i].id)
            box.find(".comment_body").html(data["new_comments"][i].content)
            box.find(".signature_box").html(data["new_comments"][i].signature)
            box.find(".comment_id").val(data["new_comments"][i].id)
            box.find(".show_responses").click(data["new_comments"][i].id, function(e) { load_new_responses(e.data) } )
            box.slideDown()
        }
    });
}

function new_comment_box(comment_id) {
    var comment_box_id = "comment_box_" + comment_id
    $(".comment_area").append($('<div class="comment_box" id="new_comment_box"> \
    <input type="hidden" class="comment_id"> \
    </input> \
    <div class="vote_box"> \
        <button class="up_comment" onclick="up_comment(' + comment_box_id + ')"> \
            up \
        </button> \
        <button class="down_comment" onclick="down_comment(' + comment_box_id + ')"> \
            down \
        </button> \
    </div> \
    <div class="comment_body"> \
    </div> \
    <div class="signature_box"> \
    </div> \
    <button class="add_text_area" onclick="add_text_area(' + comment_box_id + ')">\
        reply \
    </button>\
    <div class="new_text_area"> \
        <textarea class="new_text"> \
        </textarea> \
        <input type="checkbox" class="anonymous_check" value="anonymous"> \
            reply anonymously \
        </input> \
        <button class="submit_new_text" onclick="submit_new_response()"> \
            submit \
        </button> \
    </div> \
    <button class="show_responses">\
        show responses \
    </button>\
</div>'))
    $("#new_comment_box").attr("id", comment_box_id)
    var box = $("#comment_box_" + comment_id)
    box.hide()
    return box
}

function up_comment(box) {
    $.post("up_comment", {"comment_id" : $("#" + box.id).find(".comment_id").val()})
}

function up_response(box) {
    $.post("up_response", {"response_id" : $("#" + box.id).find(".response_id").val()})
}

function down_comment(box) {
    box.style.display = "none"
    $.post("down_comment", {"comment_id" : $("#" + box.id).find(".comment_id").val()})
}

function down_response(box) {
    box.style.display = "none"
    $.post("down_response", {"response_id" : $("#" + box.id).find(".response_id").val()})
}

function add_text_area(comment_box_id) {
    var this_box = $("#" + comment_box_id.id)
    console.log(this_box)
    console.log(this_box.find(".new_text_area"))
    this_box.find(".add_text_area")[0].remove()
    this_box.find(".new_text_area")[0].style.display = "block"
}

function load_new_responses(comment_id) {
// TODO: show upvote
    $("#comment_box_" + comment_id).find(".show_responses").remove()
    $("#comment_box_" + comment_id).find(".show_more_responses").remove()
    $.get( "get_responses?comment_id=" + comment_id + "&num_needed=3", function( data ) {
        for(var i = 0; i < data["new_responses"].length; i++) {
            var box = new_response_box(comment_id, data["new_responses"][i].id)
            console.log("Yo response: " + data["new_responses"][i].content)
            box.find(".response_body").html(data["new_responses"][i].content)
            box.find(".signature_box").html(data["new_responses"][i].signature)
            box.find(".response_id").val(data["new_responses"][i].id)
            box.slideDown()
        }
        var more_responses_buttons = $("#comment_box_" + comment_id).find(".show_more_responses")
        if (more_responses_buttons.length == 0 && data["new_responses"].length != 0) {
            var new_button = $("#comment_box_" + comment_id).append($('<button class="show_more_responses" onclick="load_new_responses(' + comment_id + ')">Show More Responses</button>'))
        }
    });
}

function load_wrapper(e) {
    load_new_responses(e.data)
}

function new_response_box(comment_id, response_id) {
    response_box_id = "response_box_" + response_id
    $("#comment_box_" + comment_id).append($(
'<div class="response_box" id="new_response_box"> \
    <input type="hidden" class="response_id"> \
    </input> \
    <div class="vote_box"> \
        <button class="up_response" onclick="up_response(' + response_box_id + ')"> \
            up \
        </button> \
        <button class="down_response" onclick="down_response(' + response_box_id + ')"> \
            down \
        </button> \
    </div> \
    <div class="response_body"> \
    </div> \
    <button class="add_text_area" onclick="add_text_area(' + response_box_id + ')">\
        reply \
    </button>\
    <div class="new_text_area"> \
        <textarea class="new_text"> \
        </textarea> \
        <input type="checkbox" class="anonymous_check" value="anonymous"> \
            reply anonymously \
        </input> \
        <button class="submit_new_text" onclick="submit_new_r_response()"> \
            submit \
        </button> \
    </div> \
    <div class="signature_box"> \
    </div> \
</div>'))
    $("#new_response_box").attr("id","response_box_" + response_id)
    var box = $("#response_box_" + response_id)
    box.hide()
    return box
}

function submit_new_response() {
// parameters needed: content, content of what's being responded to, signature used by person being responded to
// and signature, which is either "anonymous" or username depending on anonymous_check
    $.post("submit_new_response", {"response_id" : $("#" + box.id).find(".response_id").val()})
}

function submit_new_r_response() {
}

$(document).ready(function() {
    load_new_comments(2)
    $("#show_more_comments").click(function() {
        load_new_comments(2)
    })
    $(".add_comment").click(function() {
    })
    $("#submit_new_comment").click(function() {
        var data = {}
        data["activity_type_id"] = 2
        data["content"] = $("#new_comment").val()
        data["anonymous"] = $("#anonymous").val()
        $.post("add_comment", data)
    })
    $("#submit_new_response").click(function() {
        var data = {}
        data["comment_id"] = $(".comment_id").val()
        data["content"] = $("#new_response").val()
        data["anonymous"] = $("#anonymous").val()
        $.post("add_response", data)
    })
})
