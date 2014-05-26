function load_new_comments(activity_type_id) {
// TODO: show upvote
    $.get( "get_comments?activity_type_id=" + activity_type_id + "&num_needed=3", function( data ) {
        for(var i = 0; i < data["new_comments"].length; i++) {
            var box = new_comment_box()
            box.find(".comment_body").html(data["new_comments"][i].content)
            box.find(".signature_box").html(data["new_comments"][i].signature)
            box.find(".comment_id").val(data["new_comments"][i].id)
        }
    });
}

function new_comment_box() {
    var new_box_id = $(".comment_area .comment_box").length
    $(".comment_area").append($(
'<div class="comment_box" id="new_comment_box"> \
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
    <button class="show_responses">
    </button>
    <div class="comment_body"> \
    </div> \
    <div class="signature_box"> \
    </div> \
</div>'))
    $("#new_comment_box").attr("id","comment_box_" + new_box_id)
    return $("#comment_box_" + new_box_id)
}

function load_new_responses(comment_id) {
// TODO: show upvote
    $.get( "get_responses?comment_id=" + comment_id + "&num_needed=3", function( data ) {
        for(var i = 0; i < data["new_responses"].length; i++) {
            var box = new_response_box(comment_id)
            box.find(".response_body").html(data["new_responses"][i].content)
            box.find(".signature_box").html(data["new_responses"][i].signature)
            box.find(".response_id").val(data["new_responses"][i].id)
        }
    });
}

function new_response_box(comment_id) {
    var new_box_id = $(".comment_box_" + comment_id + " .response_box").length
    $(".comment_box_" + comment_id).append($(
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
    <button class="show_more_responses">
    </button>
    <div class="response_body"> \
    </div> \
    <div class="signature_box"> \
    </div> \
</div>'))
    $("#new_response_box").attr("id","response_box_" + new_box_id)
    return $("#response_box_" + new_box_id)
}

//TODO: use username as default value for signature

$(document).ready(function() {
    load_new_comments()
    $("#show_more_comments").click(function() {
        load_new_comments(1)
    })
    $("#add_new_comment").click(function() {
        var data = {}
        data["activity_type_id"] = 1
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
    $(".show_more_responses").click(function() {
        load_new_responses($(this).parentsUntil(".comment_box").find(".comment_id").val())
    })
    $("#add_new_response").click(function() {
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
})
