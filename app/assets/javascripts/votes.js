function sendVote(qid, votestring) {
  $.ajax({
    url: '/questions/' + qid + votestring,
    type: 'POST',
    dataType: "JSON",
    data: {"_method": "put"}
  })
    .done(function(data) {
      $('#' + qid).text(data);
    })
    .fail(function() {
      alert("Cannot vote for the same question more than once.");
    });
}

function initVote() {
  $('.upvote-button').unbind().click(function(ev) {
    ev.preventDefault(); // prevents bootstrap from automatically adding a hidden attribute
    var $upvote = $(ev.target).closest('.upvote-button');
    var upvoteqid = $upvote.data('vote-qid');
    sendVote(upvoteqid, '/upvote');
  });

  $('.downvote-button').unbind().click(function(ev) {
    ev.preventDefault(); // prevents bootstrap from automatically adding a hidden attribute
    var $downvote = $(ev.target).closest('.downvote-button');
    var downvoteqid = $downvote.data('vote-qid');
    sendVote(downvoteqid, '/downvote');
  });
}