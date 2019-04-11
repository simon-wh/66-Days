window.onload = function(){

};

function requestEngagementChartData(){
  
  let week = document.getElementById('weekNumberInput').value;
  let month = document.getElementById('monthInput').value;
  let year = document.getElementById('yearInput').value;
  
  let requestURL = location.origin + "/web-api/get-engagement/" + year + "/" + month;
  
  if (week != "None"){
    requestURL += "/" + week;
  }
  
  //https://www.w3schools.com/xml/tryit.asp?filename=tryajax_get
  let xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
      engagementValues = JSON.parse(this.responseText);
      if (week != "None"){
        loadWeeklyEngagementChart(engagementValues, year, month, week);
      } else {
        loadMonthlyEngagementChart(engagementValues, year, month);
      }
    }
  };
  
  xhttp.open("GET", requestURL, true);
  xhttp.send();
  
  
}

function getFullMonthName(number){
  switch(number){
    case "01":
      return "Jan";
    case "02":
      return "Feb";
    case "03":
      return "Mar";
    case "04":
      return "Apr";
    case "05":
      return "May";
    case "06":
      return "Jun";
    case "07":
      return "Jul";
    case "08":
      return "Aug";
    case "09":
      return "Sep";
    case "10":
      return "Oct";
    case "11":
      return "Nov";
    case "12":
      return "Dec";
  }
}

function getNumberOfUsersEngagedText(engagementValues){
  if (engagementValues[70] == 1){
    return "(" +engagementValues[70]+ " User)";
  } else if(engagementValues[70] > 1){
    return "(" +engagementValues[70]+ " Users)";
  } else {
    return "(No Users in Selected Range)";
  }
}

function loadWeeklyEngagementChart(engagementValues, year, month, weekOfMonth){
  let weekOfMonthText;
  
  switch(weekOfMonth){
    case "1":
      weekOfMonthText = "1st Week"; break;
    case "2":
      weekOfMonthText = "2nd Week"; break;
    case "3":
      weekOfMonthText = "3rd Week"; break;
    case "4":
      weekOfMonthText = "4th Week"; break;
    default:
      break;
  }

  
  let message = "Progress of Users Starting in the " + weekOfMonthText + " of " + getFullMonthName(month) + " " + year + " " + getNumberOfUsersEngagedText(engagementValues); 
  loadEngagementChart(engagementValues, message);
}

function loadMonthlyEngagementChart(engagementValues, year, month){
  let message = "Progress of Users Starting in " + getFullMonthName(month) + " " + year + " " + getNumberOfUsersEngagedText(engagementValues); 
  loadEngagementChart(engagementValues, message);
}

function loadEngagementChart(engagementValues, message){
  let daysInChart = -1;
  //Find the last non-zero element in engagementValues.
  for (let i = 69; i > 0; i--){
    if (engagementValues[i] != 0){
      daysInChart = i;
      break;
    }
  }
  
  let dayNumbers = [];
  let dayScores = [];
  for (let i = 1; i <= daysInChart; i++){
    dayNumbers.push(i);
    dayScores.push(engagementValues[i]);
  }
  
  let ctx = document.getElementById('engagementChart');
  let chart = new Chart(ctx, {
    type: 'line',
    data: {
      labels: dayNumbers,
      datasets: [{
        label: message,
        backgroundColor: 'rgba(92,184,92, 0.5)',
        borderColor: 'rgba(92,184,92,1)',
        data: dayScores
      }]
    },
    options: {
      legend: {
        labels: {
          // This more specific font property overrides the global property
          //fontColor: 'black',
          fontSize: 16
        }
      },
      scales: {
        yAxes: [{
          scaleLabel: {
            display: true,
            labelString: 'Average Habits Checked',
            fontSize: 16
          }
        }],
        xAxes: [{
          scaleLabel: {
            display: true,
            labelString: 'Day Of Course',
            fontSize: 16
          }
        }],
      }
    }
  });
}

