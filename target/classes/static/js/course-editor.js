
function hideAllWeeks(){
    $( ".week" ).hide(300);
}

function displayWeek(weekId){
    hideAllWeeks();
    $(weekId).show(300);
}

window.onload = function(){
    hideAllWeeks();
    $( "#week-One" ).show(300);
}
