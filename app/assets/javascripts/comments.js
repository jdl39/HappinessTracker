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
    $(".comment_area").append($('<div class="comment_box" id="new_comment_box"> \
    <input type="hidden" class="comment_id"> \
    </input> \
    <div class="vote_box"> \
        <button class="up_comment"> \
            up \
        </button> \
        <button class="down_comment"> \
            down \
        </button> \
    </div> \
    <div class="comment_body"> \
    </div> \
    <div class="signature_box"> \
    </div> \
    <button class="show_responses">\
        show responses \
    </button>\
    <button class="add_response">\
        reply \
    </button>\
</div>'))
    $("#new_comment_box").attr("id","comment_box_" + comment_id)
    var box = $("#comment_box_" + comment_id)
    box.hide()
    return box
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
            var new_button = $("#comment_box_" + comment_id).append($('<button class="show_more_responses">Show More Responses</button>'))
            new_button.click(comment_id, function(e) { load_new_responses(e.data) } )
        }
    });
}

function new_response_box(comment_id, response_id) {
    $("#comment_box_" + comment_id).append($(
'<div class="response_box" id="new_response_box"> \
    <input type="hidden" class="response_id"> \
    </input> \
    <div class="vote_box"> \
        <button class="up_vote"> \
            up \
        </button> \
        <button class="down_vote"> \
            down \
        </button> \
    </div> \
    <div class="response_body"> \
    </div> \
    <div class="signature_box"> \
    </div> \
    <button class="add_r_response">\
        reply \
    </button>\
</div>'))
    $("#new_response_box").attr("id","response_box_" + response_id)
    var box = $("#response_box_" + response_id)
    box.hide()
    return box
}

$(document).ready(function() {
    load_new_comments(2)
    $("#show_more_comments").click(function() {
        load_new_comments(2)
    })
    $(".new_comment").click(function() {
    })
    $("#submit_new_comment").click(function() {
        var data = {}
        data["activity_type_id"] = 2
        data["content"] = $("#new_comment").val()
        data["signature"] = $("#signature").val()
        $.post("add_comment", data)
    })
    $(".up_comment").click(function() {
        var comment_box = $(this).parentsUntil(".comment_box")
        $.post("up_comment", {"comment_id" : comment_box.find(".comment_id").val()})
    })
    $(".down_comment").click(function() {
        var comment_box = $(this).parentsUntil(".comment_box")
        $.post("down_comment", {"comment_id" : comment_box.find(".comment_id").val()})
    })
    $(".new_response").click(function() {
    })
    $("#submit_new_response").click(function() {
        var data = {}
        data["comment_id"] = $(".comment_id").val()
        data["content"] = $("#new_response").val()
        data["signature"] = $("#signature").val()
        $.post("add_response", data)
    })
    $(".up_response").click(function() {
        var comment_box = $(this).parentsUntil(".response_box")
        $.post("up_response", {"response_id" : comment_box.find(".response_id").val()})
    })
    $(".down_response").click(function() {
        var comment_box = $(this).parentsUntil(".response_box")
        $.post("down_response", {"response_id" : comment_box.find(".response_id").val()})
    })
    // r_response: a personal message responding to a response; in short, a response response
    $(".new_r_response").click(function() {
    })
    $("#submit_new_resply").click(function() {
    })
})

function create_text_box() {
    html =
'   <textarea id="new_comment"> \
    </textarea> \
    <input type="text" id="signature" value="<%= current_user.username %>"> \
    </input> '
}
