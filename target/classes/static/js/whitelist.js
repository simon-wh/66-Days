window.onload = function(){
    console.log("Load the users from the server.");
    let emailList = getEmailWhitelist();
    console.log("Display the whitelist to the screen.");
    addEmailsToHTML(emailList);
    console.log("Add email address to the server.");
    let response = addEmailToWhitelist("jhancock125@gmail.com");
    console.log(response);
    console.log("Load the users from the server.");
    emailList = getEmailWhitelist();
    console.log("Display the whitelist to the screen.");
    addEmailsToHTML(emailList);
}

const getEmailWhitelist = async () => {
    const response = await fetch('/web-api/all-emails');
    const emailWhitelist = await response.json();
    return emailWhitelist;
}

const addEmailToWhitelist = async (emailAddress) => {
    const response = await fetch('/web-api/add-email?email=' + emailAddress);
    return response;
}

function addEmailsToHTML(emailList){
    console.log(emailList);
}

function addEmailAddressToHTML() {
    let emailListElement = '<li class="list-group-item" id="'
    emailListElement += document.getElementById("emailInput").value;
    emailListElement += 'Element">';
    emailListElement += document.getElementById("emailInput").value;
    emailListElement += '<button class="btn btn-small btn-danger float-right" ';
    emailListElement += `onclick="deleteListElement('`;
    emailListElement += document.getElementById("emailInput").value;
    emailListElement += "Element";
    emailListElement += `')">Delete</button></li>`;
                            
    document.getElementById("emailAddressList").insertAdjacentHTML('beforeend', emailListElement);
}

function deleteListElement(elementId){
    let deleteEmail = confirm("Are you sure you want to delete this email?");
    if (deleteEmail){
        var element = document.getElementById(elementId);
        element.parentNode.removeChild(element);
    }
}

