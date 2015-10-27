$(function() {
    changeNavigation();
});

// function to handle the navigation of the navigation bar
function changeNavigation() {
    $('.nav.nav-pills li').removeClass('active');
    var navigation = window.location.pathname.toString().trim().toLowerCase();
    if (navigation.indexOf('/customers') > -1) {
        $($('.nav.nav-pills li')[1]).addClass('active');
    } else if (navigation.indexOf('/statements') > -1) {
        $($('.nav.nav-pills li')[2]).addClass('active');
    } else if (navigation.indexOf('/transactions') > -1) {
        $($('.nav.nav-pills li')[3]).addClass('active');
    } else if (navigation.indexOf('/bulk_uploads') > -1) {
        $($('.nav.nav-pills li')[4]).addClass('active');
    } else {
        $($('.nav.nav-pills li')[0]).addClass('active');
    }
}
