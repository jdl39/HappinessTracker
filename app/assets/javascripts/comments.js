function load_new_comments(activity_type_id) {
// TODO: show upvote
    $.get( "get_comments?activity_type_id=" + activity_type_id + "&num_needed=3", function( data ) {
        for(var i = 0; i < data["new_comments"].length; i++) {
            var box = new_comment_box()
            box.find(".comment_body").html(data["new_comments"][i].content)
            box.find(".signature_box").html(data["new_comments"][i].signature)
        }
    });
}

function new_comment_box() {
    var new_box_id = $(".comment_area .comment_box").length
    $(".comment_area").append($(
'<div class="comment_box" id="new_comment_box"> \
    <div class="vote_box"> \
        <button class="up_vote"> \
            up \
        </button> \
        <button class="down_vote"> \
            down bitch \
        </button> \
    </div> \
    <div class="comment_body"> \
    </div> \
    <div class="signature_box"> \
        Nietzche \
    </div> \
</div>'))
    $("#new_comment_box").attr("id","comment_box_" + new_box_id)
    return $("#comment_box_" + new_box_id)
}

$(document).ready(function() {
    load_new_comments()
    $("#show_more_comments").click(function() {
        load_new_comments(1)
    })
})
