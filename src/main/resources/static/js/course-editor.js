
window.onload = function(){

}

$('#habitLinkList').on('change',function(){
  let habitSelected = $("#habitLinkList option:selected").text();
  $("#habitTitle").text(habitSelected);
  $("#habitTitle").attr("value", habitSelected);
  console.log("HABIT LINK CHANGE - The habit title value is now", habitSelected);
});

//Whenever the weekType dropdown input element is updated...
$('#weekType').on('change',function(){
  let weekTypeSelected = $(this).val();
  
  updateGUIAfterWeekTypeChanged(weekTypeSelected);
  
  if (weekTypeSelected == "UPDATE_OLD_HABIT") {
    let habitSelected = $("#habitLinkList option:selected").text();
    $("#habitTitle").text(habitSelected);
    $("#habitTitle").attr("value", habitSelected);
    console.log("WEEKTYPE CHANGE - The habit title value is now", $("#habitLinkList option:selected").text());
  }
  
  //Clears the habit input value so the user can enter something new.
  //This would otherwise display "Habit for Week x" - I prefer a blank slate.
  //Emptying the textbox creates a red outline around it, prompting the user to enter a value.
  if (weekTypeSelected == "CREATE_NEW_HABIT") {
    $("#habitTitle").val("");
  }
  
});

function updateGUIAfterWeekTypeChanged(weekType){
  
    if (weekType == "CREATE_NEW_HABIT"){
        $( "#enterTitleOfHabit").removeClass("hideElement");
        $( "#listOfExperimentsSection").removeClass("hideElement");

        $( "#enterTitleOfHabit").show(300);
        $( "#listOfExperimentsSection").show(300);
        $( "#linkToPreviousHabit").hide();
    }

    if (weekType == "UPDATE_OLD_HABIT"){
        $( "#linkToPreviousHabit").removeClass("hideElement")
        $( "#listOfExperimentsSection").removeClass("hideElement")

        $( "#linkToPreviousHabit").show(300);
        $( "#listOfExperimentsSection").show(300);
        $( "#enterTitleOfHabit").hide();
    }

    if (weekType == "JUST_DESCRIPTION"){
        $( "#linkToPreviousHabit").hide();
        $( "#enterTitleOfHabit").hide();
        $( "#listOfExperimentsSection").hide();
    }
  
}
