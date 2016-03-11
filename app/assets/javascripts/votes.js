function sendVote(qid, votestring) {
  $.ajax({
    url: '/questions/' + qid + votestring,
    type: 'POST',
    dataType: "JSON",
    data: {"_method": "put"}
  })
    .done(function(data) {
      $('#question-' + qid + '-net-votes').text(data);
    })
    .fail(function() {
      alert("Cannot vote for the same question more than once.");
    });
}

function initVote() {
  $('.upvote-button').click(function(ev) {
    var $upvote = $(ev.target).closest('.upvote-button');
    var upvoteqid = $upvote.data('vote-qid');
    sendVote(upvoteqid, '/upvote');
  });

  $('.downvote-button').click(function(ev) {
    var $downvote = $(ev.target).closest('.downvote-button');
    var downvoteqid = $downvote.data('vote-qid');
    sendVote(downvoteqid, '/downvote');
  });
}
