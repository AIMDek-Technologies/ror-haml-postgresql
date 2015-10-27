var app = app || {};
$(function(){

    var origin = window.location.origin;
    app.credit_cards = [];
    app.selected_credit_card;
    $('#add_transaction').click(function(){
        var url = origin + '/transactions/new';
        $.ajax({
            url: url,
            type: 'get'
        }).success(function(response){
            $('#modal-data').html(response);
            $('#transactionModel .modal-title').html('Add Transaction');
            enableFunctionOfModel();
        });
    });

    // function to enable the functions of the model dialog
    function enableFunctionOfModel(){
        $('#transaction_user_id').change(function(){
            var user_id = $('#transaction_user_id').val();
            var url = origin + '/credit_cards_of_user/'+user_id;
            if(user_id != '') {
                $.ajax({
                    url: url,
                    type: 'get'
                }).success(function (response) {
                    app.credit_cards = response;
                    if(response.length == 1){
                        app.selected_credit_card = response[0];
                        $('#balance').html('Available balance is ₹.' + app.selected_credit_card.available_credit_limit);
                        $('#balance').css('color', 'black');
                    }
                    $('#transaction_credit_cards').html('');
                    for (var i = 0; i < response.length; i++) {
                        var option = document.createElement('option');
                        option.setAttribute('value', response[i].id);
                        option.innerHTML = response[i].card_number + ' ('+ response[i].name_on_card+')';
                        $('#transaction_credit_cards').append(option);
                    }
                });
            }
        });

        // to display available balance on card select
        $('#transaction_credit_cards').blur(function(){
            var credit_card_id = $('#transaction_credit_cards').val();
            for(var i=0;i<app.credit_cards.length;i++){
                if(app.credit_cards[i].id == credit_card_id){
                    app.selected_credit_card = app.credit_cards[i];
                    break;
                }
            }
            $('#balance').html('Available balance is ₹.' + app.selected_credit_card.available_credit_limit);
        });

        // to display remaining balance
        $('#transaction_amount').blur(function(){
            var amount = $('#transaction_amount').val();
            if(parseFloat(amount) >= 0) {
                var balance = app.selected_credit_card.available_credit_limit - amount;
                if (balance < 0) {
                    $('#balance').css('color', 'red');
                    $('#balance').html('Transaction amount is exceeded from the available balance.');
                    $('#transaction_balance').val();
                } else {
                    $('#balance').css('color', 'blue');
                    $('#transaction_balance').val(balance);
                    $('#balance').html('Remaining balance is ₹.' + balance);
                }
            }else if(typeof app.selected_credit_card == 'undefined'){
                $('#balance').css('color', 'red');
                $('#balance').html('Please select customer and credit card first.');
            }
        });
    }

    // to handle searching on transaction table
    $("#transactions_search .form-control").keyup(function(e){
        $.get($("#transactions_search").attr("action"), $("#transactions_search").serialize(), null, "script");
        e.preventDefault();
    });


});