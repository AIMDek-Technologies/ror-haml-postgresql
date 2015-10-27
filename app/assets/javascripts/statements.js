$(function(){
    // to handle searching on statements table
    $("#statements_search .form-control").keyup(function(e){
        $.get($("#statements_search").attr("action"), $("#statements_search").serialize(), null, "script");
        e.preventDefault();
    });
});


