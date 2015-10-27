$(function(){

    // to handle searching on bulk uploads table
    $("#bulkUploads_search .form-control").keyup(function(e){
        $.get($("#bulkUploads_search").attr("action"), $("#bulkUploads_search").serialize(), null, "script");
        e.preventDefault();
    });

});
