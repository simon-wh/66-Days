const userAction = async () => {
    const response = await fetch('/web-api/all-emails');
    const emailWhitelist = await response.json();//extract JSON from http response
    console.log(emailWhitelist);
}