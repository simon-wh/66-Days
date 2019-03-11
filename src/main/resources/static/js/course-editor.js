
let currentWeekId = 1;

function hideAllWeeks(){
    $( ".week" ).hide(300);
}

function displayWeek(weekIdAsString, weekIdNumber){
    currentWeekId = weekIdNumber;
    console.log(currentWeekId);
    hideAllWeeks();
    $(weekIdAsString).show(300);
}

window.onload = function(){
    hideAllWeeks();
    $( "#week-One" ).show(300);
}

$('.habitLinkListClass').on('change',function(){
    let optionValue = $(this).val();
    $("#habitTitle").text(optionValue);
    console.log("The habit title is now: ", $( "#habitTitle" ).text());
});

$('.weekTypeClass').on('change',function(){
    let optionValue = $(this).val();

    if (optionValue == "CREATE_NEW_HABIT"){
        $( "#enterTitleOfHabit" + currentWeekId).removeClass("hideElement")
        $( "#listOfExperimentsSection" + currentWeekId).removeClass("hideElement")
        $( "#enterTitleOfHabit" + currentWeekId).show(300);
        $( "#listOfExperimentsSection" + currentWeekId).show(300);
        $( "#linkToPreviousHabit" + currentWeekId).hide();
    }

    if (optionValue == "UPDATE_OLD_HABIT"){
        $( "#linkToPreviousHabit" + currentWeekId ).removeClass("hideElement")
        $( "#listOfExperimentsSection" + currentWeekId ).removeClass("hideElement")
        $( "#linkToPreviousHabit" + currentWeekId ).show(300);
        $( "#listOfExperimentsSection" + currentWeekId ).show(300);
        $( "#enterTitleOfHabit" + currentWeekId ).hide();
    }

    if (optionValue == "JUST_DESCRIPTION"){
        $( "#linkToPreviousHabit" + currentWeekId ).hide();
        $( "#enterTitleOfHabit" + currentWeekId ).hide();
        $( "#listOfExperimentsSection" + currentWeekId ).hide();
    }
});
