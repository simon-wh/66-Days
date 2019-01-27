window.onload = function(){
    var ctx = document.getElementById('overallChart');
    console.log(ctx);
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
};