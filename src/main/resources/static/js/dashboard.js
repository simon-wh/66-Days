window.onload = function(){

};

function requestEngagementChartData(){
  let year = document.getElementById('yearInput').value;
  let month = document.getElementById('monthInput').value;
  
  let requestURL = location.origin + "/web-api/get-engagement/" + year + "/" + month;
  
  
  //https://www.w3schools.com/xml/tryit.asp?filename=tryajax_get
  let xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
      engagementValues = JSON.parse(this.responseText);
      loadEngagementChart(engagementValues, year, month);
    }
  };
  xhttp.open("GET", requestURL, true);
  xhttp.send();
  
}

function loadEngagementChart(engagementValues, year, month){
  
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
        label: "Engagement with 66 Days " + month + "/" + year,
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

function loadDefaultChart(){    
  var ctx = document.getElementById('engagementChart');
  var chart = new Chart(ctx, {
      type: 'line',
      data: {
          labels: ["Week 1", "Week 2", "Week 3", "Week 4", "Week 5", "Week 6", "Week 7", "Week 8", "Week 9", "Week 10"],
          datasets: [{
              label: "Overall User Interaction with 66 Days",
              backgroundColor: 'rgba(92,184,92, 0.5)',
              borderColor: 'rgba(92,184,92,1)',
              data: [0, 10, 5, 2, 20, 30, 35, 32, 40, 45],
          }]
      },
      options: {
          legend: {
              labels: {
                  // This more specific font property overrides the global property
                  fontColor: 'black',
                  fontSize: 18
              }
          }
      }

  });
}