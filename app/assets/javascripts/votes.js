function sendUpvote(qid) {
  $.ajax({
    url: '/questions/' + qid + '/upvote',
    type: 'POST',
    dataType: "JSON",
    data: {"_method": "put"}
  })
    .done(function(data) {
      console.log(data);
    })
    .fail(function() {
      console.log("failed");
    });
}

function sendDownvote(qid) {
  $.ajax({
    url: '/questions/' + qid + '/downvote',
    type: 'POST',
    dataType: "JSON",
    data: {"_method": "put"}
  })
    .done(function(data) {
      console.log(data);
    })
    .fail(function() {
      console.log("failed");
    });
}

function initVote() {
  $('.upvote-button').unbind().click(function(ev) {
    ev.preventDefault(); // prevents bootstrap from automatically adding a hidden attribute
    var $upvote = $(ev.target).closest('.upvote-button');
    var upvoteqid = $upvote.data('vote-qid');
    sendUpvote(upvoteqid);
  });

  $('.downvote-button').unbind().click(function(ev) {
    ev.preventDefault(); // prevents bootstrap from automatically adding a hidden attribute
    var $downvote = $(ev.target).closest('.downvote-button');
    var downvoteqid = $downvote.data('vote-qid');
    sendDownvote(downvoteqid);
  });
}