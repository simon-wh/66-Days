
window.onload = function(){

}

$('#habitLinkList').on('change',function(){
    let optionValue = $("#habitLinkList option:selected").text();
    $("#habitTitle").text(optionValue);
    //console.log("The habit title is now: ", $( "#habitTitle" ).text());
});

//Whenever the weekType dropdown input element is updated...
$('#weekType').on('change',function(){
  let optionValue = $(this).val();
  
  updateGUIAfterWeekTypeChanged(optionValue);
  
  if (optionValue == "UPDATE_OLD_HABIT") {
    $("#habitTitle").val($("#habitLinkList option:selected").text());
    //console.log("The habit title is now: ", $( "#habitTitle" ).val());
  }
  
  if (optionValue == "CREATE_NEW_HABIT") {
    $("#habitTitle").val("");
  }
  
});

function updateGUIAfterWeekTypeChanged(optionValue){
  
    if (optionValue == "CREATE_NEW_HABIT"){
        $( "#enterTitleOfHabit").removeClass("hideElement");
        $( "#listOfExperimentsSection").removeClass("hideElement");

        $( "#enterTitleOfHabit").show(300);
        $( "#listOfExperimentsSection").show(300);
        $( "#linkToPreviousHabit").hide();
    }

    if (optionValue == "UPDATE_OLD_HABIT"){
        $( "#linkToPreviousHabit").removeClass("hideElement")
        $( "#listOfExperimentsSection").removeClass("hideElement")

        $( "#linkToPreviousHabit").show(300);
        $( "#listOfExperimentsSection").show(300);
        $( "#enterTitleOfHabit").hide();
    }

    if (optionValue == "JUST_DESCRIPTION"){
        $( "#linkToPreviousHabit").hide();
        $( "#enterTitleOfHabit").hide();
        $( "#listOfExperimentsSection").hide();
    }
  
}
